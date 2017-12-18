class Tab3::AppVideoController < ApplicationController

  #获取视频大类
  def get_category_list
    key = "get_category_list"
    redis_json = $redis.get(key)
    render json: eval(redis_json) and return if !redis_json.blank?
    list_hash = AppVideoCategory.all.map {|item|
      item_hash = item.as_json(only: [:id, :name])
      item_hash
    }
    json = {status: 0, contents: list_hash}
    $redis.setex(key, 10, json)
    render json: json and return

  end

  #获取视频列表
  #parmas:id,page
  def get_video_list
    category_id = params[:id].to_i
    page = params[:page].to_i
    if category_id == 1
      page = 1
      per = 1
    else
      per = 5
    end

    list = AppVideoCategory.find_by_id(category_id).app_videos.order(created_at: :desc).page(page).per(per)
    key = "get_video_list_#{list.map(&:id).join("_")}"
    redis_json = $redis.get(key)
    render json: eval(redis_json) and return if !redis_json.blank?

    list_hash = list.map {|item|
      item_hash = item.as_json(only: [:id, :name, :view_count, :vu, :uu, :snapshot_url])
      item_hash["comment_count"] = item.app_video_comments.count
      item_hash["like_count"] = item.app_video_likes.count
      item_hash["collection_count"] = AppCollection.where(collection_type: "video", item_id: item.id).count
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmd(item.created_at)
      # is_liked是无用字段，直接给false
      item_hash["is_liked"] = false
      item_hash["is_collected"] = true
      item_hash["view_count"] = item.view_count
      item_hash["tags"] = item.app_video_categories.map(&:name).join(",")
      item_hash
    }
    json = {status: 0, contents: list_hash}
    $redis.setex(key, 10, json)
    render json: json and return

  end

  # 获取视频详情
  # params:id,token
  def get_video_detail

    video_id = params[:id].to_i
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "用户无效"} and return if user.blank?

    key = "get_video_detail_#{video_id}"
    redis_json = $redis.get(key)
    render json: eval(redis_json) and return if !redis_json.blank?

    item = AppVideo.find_by_id(video_id)
    item_hash = item.as_json(only: [:id, :name, :view_count, :vu, :uu, :snapshot_url])
    item_hash["like_count"] = item.app_video_likes.count
    item_hash["collection_count"] = AppCollection.where(collection_type: "video", item_id: item.id).count
    item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmd(item.created_at)
    item_hash["is_liked"] = get_video_is_liked(item.id, user.id)
    item_hash["is_collected"] = true
    tags = item.app_video_categories.map(&:name).join(",")
    json = {status: 0, content: item_hash, tags: tags}
    $redis.setex(key, 10, json)
    render json: json and return
  end

  #获取视频评论
  #params: id,page,token
  def get_video_comment

    video_id = params[:id].to_i
    page = params[:page]
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "用户无效"} and return if user.blank?
    video = AppVideo.find(video_id)
    comments = video.app_video_comments.order('created_at DESC').page(page).per(5)

    key = "get_video_comment_#{comments.map(&:id).join("_")}"
    redis_json = $redis.get(key)
    render json: eval(redis_json) and return if !redis_json.blank?

    comments_hash = comments.map {|item|
      item_hash = item.as_json(only: [:id, :app_user_id, :to_user_id, :content])
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      item_hash["username"] = item.app_user.username
      item_hash["usericon"] = generate_user_avatar_url(item.app_user)
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      if !item.to_user_id.blank?
        to_user = AppUser.find(item.to_user_id)
        item_hash["to_user_username"] = to_user.username
        item_hash["to_user_usericon"] = generate_user_avatar_url(to_user)
      end
      item_hash
    }
    comment_count = video.app_video_comments.count
    json = {status: 0, contents: comments_hash, message: "获取成功", comment_count: comment_count}
    $redis.setex(key, 10, json)
    render json: json

  end

  #发布视频评论
  #params:id,comment,token   optional:to_user_id,to_comment_id
  def publish_video_comment
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    comment = params[:comment]
    render json: {status: 2, message: "评论内容不能为空"} and return if comment.blank?

    video_id = params[:id]
    video = AppVideo.find(video_id)
    render json: {status: 3, message: "视频不存在"} and return if video.blank?

    to_user_id = params[:to_user_id]
    to_comment_id = params[:to_comment_id]
    newData = video.app_video_comments.new(app_user_id: user.id, to_user_id: to_user_id,
                                           content: comment, to_comment_id: to_comment_id)
    if newData.save
      render json: {status: 0, message: "评论成功"} and return
    else
      render json: {status: 0, message: "评论失败"} and return
    end

  end

  # 获取视频是否点赞
  # params: id,token
  def is_liked
    video_id = params[:id].to_i
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "用户无效"} and return if user.blank?
  end

  # 点赞视频
  # params:id,token
  def like_video
    video_id = params[:id]
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?
    is_liked = get_video_is_liked(video_id, user.id)
    render json: {status: 0, message: "已经点赞过"} and return if is_liked
    new_item = AppVideoLike.new(app_video_id: video_id, app_user_id: user.id)
    if new_item.save
      render json: {status: 0, message: "点赞成功"} and return
    end
    render json: {status: 0, message: "点赞失败"} and return
  end


  private
  # 获取视频是否点赞过
  def get_video_is_liked(video_id, user_id)
    count = AppVideoLike.where("app_video_id = #{video_id} and app_user_id = #{user_id}").count
    return count>0
  end

end

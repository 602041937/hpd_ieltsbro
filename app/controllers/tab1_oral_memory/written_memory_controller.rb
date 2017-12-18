class Tab1OralMemory::WrittenMemoryController < ApplicationController

  #获取写作回忆列表
  #params:page
  def written_memory_list
    key = "written_memory_list_"
    page = params[:page]
    page ||= 1
    memory_list = AppWrittenMemory.order('created_at DESC').page(page).per(5)
    key = key + memory_list.map(&:id).join("_")
    redis_data = $redis.get(key)
    render json: eval(redis_data) and return if !redis_data.blank?
    list_hash = memory_list.map {|item|
      item_hash = item.as_json(only: [:id, :reading, :writing, :listening, :extras, :location])
      p item_hash
      readings_images = item.app_written_images.where(memory_type: "reading").order(:image_order).map {
        "http://#{request.host_with_port}/app_user/avatar/2/user_default"
      }
      item_hash["readings_images"]= readings_images

      listenings_images = item.app_written_images.where(memory_type: "listening").order(:image_order).map {|image|
        "http://#{request.host_with_port}/app_user/avatar/2/user_default"
      }
      item_hash["listenings_images"]= listenings_images

      writings_images = item.app_written_images.where(memory_type: "writing").order(:image_order).map {|image|
        "http://#{request.host_with_port}/app_user/avatar/2/user_default"
      }
      item_hash["writings_images"]= writings_images
      item_hash["comment_counts"] = item.app_written_memory_comments.count
      item_hash["username"] = item.app_user.username
      item_hash["usericon"] = generate_user_avatar_url(item.app_user)
      item_hash["is_v"] = true
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmd(item.created_at)
      item_hash
    }

    json = {status: 0, contents: list_hash, message: "获取成功"}
    $redis.setex(key, 10, json)
    render json: json
    return
  end


  #写作回忆详情
  #params:id
  def written_memory_detail

    memory_id = params[:id]
    memory = AppWrittenMemory.find_by_id(memory_id.to_i)
    render json: {status: 1, message: "回忆不存在"} and return if memory.blank?
    content_hash = memory.as_json(only: [:id, :reading, :writing, :listening, :extras, :location])
    readings_images = memory.app_written_images.where(memory_type: "reading").order(:image_order).map {
      "http://#{request.host_with_port}/app_user/avatar/2/user_default"
    }
    content_hash["readings_images"]= readings_images
    content_hash["readings_images_hd"]= readings_images

    listenings_images = memory.app_written_images.where(memory_type: "listening").order(:image_order).map {|image|
      "http://#{request.host_with_port}/app_user/avatar/2/user_default"
    }
    content_hash["listenings_images"]= listenings_images
    content_hash["listenings_images_hd"]= listenings_images

    writings_images = memory.app_written_images.where(memory_type: "writing").order(:image_order).map {|image|
      "http://#{request.host_with_port}/app_user/avatar/2/user_default"
    }
    content_hash["writings_images"]= writings_images
    content_hash["writings_images_hd"]= writings_images

    content_hash["comment_counts"] = memory.app_written_memory_comments.count
    content_hash["username"] = memory.app_user.username
    content_hash["usericon"] = generate_user_avatar_url(memory.app_user)
    content_hash["is_v"] = true
    content_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmd(memory.created_at)

    comments = memory.app_written_memory_comments.order('created_at DESC').page(1).per(5)
    comment_hash = comments.map {|item|
      item_hash = item.as_json(only: [:id, :app_user_id, :to_user_id, :content])
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      item_hash["username"] = item.app_user.username
      item_hash["usericon"] = generate_user_avatar_url(item.app_user)
      if !item.to_user_id.blank?
        to_user = AppUser.find(item.to_user_id)
        item_hash["to_user_username"] = to_user.username
        item_hash["to_user_usericon"] = generate_user_avatar_url(to_user)
      end
      item_hash
    }
    render json: {status: 0, contents: content_hash, comments: comment_hash, message: "获取成功"}
    return
  end

  #发布写作回忆评论
  #params:id,comment,token   optional:to_user_id,to_comment_id
  def publish_written_memory_comment

    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    comment = params[:comment]
    render json: {status: 2, message: "评论内容不能为空"} and return if comment.blank?

    memory_id = params[:id]
    memory = AppWrittenMemory.find_by_id(memory_id)
    render json: {status: 3, message: "回忆不存在"} and return if memory.blank?

    to_user_id = params[:to_user_id]
    to_comment_id = params[:to_comment_id]
    newData = AppWrittenMemoryComment.new(app_written_memory_id: memory_id, app_user_id: user.id, to_user_id: to_user_id,
                                          content: comment, to_comment_id: to_comment_id)
    if newData.save
      render json: {status: 0, message: "评论成功"} and return
    else
      render json: {status: 0, message: "评论失败"} and return
    end
  end

  # 获取写作回忆更多评论
  # params:id,page
  def more_written_memory_comments
    memory_id = params[:id]
    page = params[:page].to_i
    page ||= 1
    memory = AppWrittenMemory.find(memory_id)
    comments = memory.app_written_memory_comments.order('created_at DESC').page(page).per(5)
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
    render json: {status: 0, memory_id: memory_id, contents: comments_hash, message: "获取成功"}
    return
  end
end

class Tab4::AppExamGroupController < ApplicationController

  #考圈列表
  #params:token,page,rel_cache,star_cache,collection_type
  #params optional:sex,location_id,date_id,app_destination_id,current_location
  def oral_practice_list
    a = Time.now
    page = params[:page].to_i
    sex = params[:sex]
    app_exam_location_id = params[:location_id]
    app_exam_date_id = params[:date_id]
    app_destination_country_id = params[:app_destination_id]
    current_location = params[:current_location]

    select_option_type = ""
    if !sex.blank?
      select_option_type = "sex = '#{sex}'"
    elsif !app_exam_location_id.blank?
      select_option_type = "app_exam_location_id = #{app_exam_location_id}"
    elsif !app_exam_date_id.blank?
      select_option_type = "app_exam_date_id = #{app_exam_date_id}"
    elsif !app_destination_country_id.blank?
      select_option_type = "app_destination_id = #{app_destination_country_id}"
    elsif !current_location.blank?
      select_option_type = "current_location = #{current_location}"
    end

    # where("")能忽略
    #AppOralPracticeComment.where(is_show: true).order(id: :desc).joins(:app_user).where("")
    comments_list = AppOralPracticeComment.where(is_show: true).order(id: :desc).page(page).per(10).joins(:app_user).where(select_option_type)
    comments_hash = comments_list.map {|item|
      item_hash = item.as_json(only: [:id, :seconds])
      # item_hash["fluent"] = 10
      item_hash["audio_record"] = generate_user_oral_practice_comment_url(item)
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      # item_hash["vocab"] = 10
      item_hash["user_id"] = item.app_user_id
      item_hash["is_stared"] = false
      item_hash["usericon"] = generate_user_avatar_url(item.app_user)
      # item_hash["grammar"] = 10 0
      item_hash["stars"] = AppOralPracticeStar.where(app_oral_practice_comment_id: item.id).sum("fluent+grammar+pronuce+vocab")
      # item_hash["pronuce"] = 10
      item_hash["username"] = item.app_user.username
      item_hash["user_id"] = item.app_user.id
      item_hash["part"] = item.app_oral_practice_question.part_num ||= 1
      item_hash["play_times"] = item.play_times
      item_hash["question_description"] = item.app_oral_practice_question.description
      item_hash["question_id"] = item.app_oral_practice_question.id
      item_hash["is_collected"] = AppCollection.get_is_collected(item.id, $COLLECTION_TYPE_ORAL_PRACTICE_COMMENT)
      item_hash["collections"] = AppCollection.get_collection_count(item.id, $COLLECTION_TYPE_ORAL_PRACTICE_COMMENT)
      item_hash["comment_count"] = item.app_oral_practice_comment_comments.count
      item_hash
    }

    json = {status: 0, top_star: get_top_star(1, 1)[0], top_practice: get_top_practice(1, 1)[0], contents: comments_hash}
    render json: json
    p "================"
    b = Time.now - a
    p b
    return
  end


  #获取评论
  #params: id,page,token
  def get_more_comments

    app_oral_practice_comment_id = params[:id].to_i
    page = params[:page]
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "用户无效"} and return if user.blank?
    practice_comment = AppOralPracticeComment.find(app_oral_practice_comment_id)
    comments = practice_comment.app_oral_practice_comment_comments.order('created_at DESC').page(page).per(5)

    key = "AppExamGroupController_get_more_comments_#{comments.map(&:id).join("_")}"
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
    json = {status: 0, contents: comments_hash, message: "获取成功"}
    $redis.setex(key, 10, json)
    render json: json
  end

  #发布评论
  #params:id,comment,token   optional:to_user_id,to_comment_id
  def publish_comment
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    comment = params[:comment]
    render json: {status: 2, message: "评论内容不能为空"} and return if comment.blank?

    app_oral_practice_comment_id = params[:id]
    practice_comment = AppOralPracticeComment.find(app_oral_practice_comment_id)
    render json: {status: 3, message: "录音不存在"} and return if practice_comment.blank?

    to_user_id = params[:to_user_id]
    to_comment_id = params[:to_comment_id]
    newData = practice_comment.app_oral_practice_comment_comments.new(app_user_id: user.id, to_user_id: to_user_id,
                                                                      content: comment, to_comment_id: to_comment_id)
    if newData.save
      render json: {status: 0, message: "评论成功"} and return
    else
      render json: {status: 0, message: "评论失败"} and return
    end

  end

  # 学霸版
  # pramas:token,days,page,rel_cache
  def top_stars

    page = params[:page].to_i
    token = params[:token]
    days = params[:days].to_i
    rel_cache = params[:rel_cache]

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?
    render json: {status: 0, contents: get_top_star(10, days)}

  end

  # 学勤版
  #pramas:token,days,page,rel_cache
  def top_practices

    page = params[:page].to_i
    token = params[:token]
    days = params[:days].to_i
    rel_cache = params[:rel_cache]

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?
    render json: {status: 0, contents: get_top_practice(10, days)}

  end

  # 考圈详情
  # params:token,id
  def oral_practice_detail

    token = params[:token]
    oral_practice_comment_id = params[:id]
    rel_cache = params[:rel_cache]

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    item = AppOralPracticeComment.find(oral_practice_comment_id)
    item_hash = item.as_json(only: [:id, :seconds])
    # item_hash["fluent"] = 10
    item_hash["audio_record"] = generate_user_oral_practice_comment_url(item)
    item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
    # item_hash["vocab"] = 10
    item_hash["user_id"] = item.app_user_id
    item_hash["is_stared"] = AppOralPracticeStar.get_is_stared(user.id, item.id)
    item_hash["usericon"] = generate_user_avatar_url(item.app_user)
    # item_hash["grammar"] = 10 0
    item_hash["stars"] = AppOralPracticeStar.where(app_oral_practice_comment_id: item.id).sum("fluent+grammar+pronuce+vocab")
    # item_hash["pronuce"] = 10
    item_hash["username"] = item.app_user.username
    item_hash["user_id"] = item.app_user.id
    item_hash["part"] = item.app_oral_practice_question.part_num ||= 1
    item_hash["play_times"] = item.play_times
    item_hash["question_description"] = item.app_oral_practice_question.description
    item_hash["topic"] = item.app_oral_practice_question.topic
    item_hash["question_title"] = item.app_oral_practice_question.topic
    item_hash["question_id"] = item.app_oral_practice_question.id
    item_hash["is_collected"] = false
    item_hash["collections"] = AppCollection.get_collection_count(item.id, "oral_practice_comment")
    item_hash["comment_count"] = item.app_oral_practice_comment_comments.count
    item_hash["relationship"] = 0
    item_hash["topic_id"] = item.app_oral_practice_question.app_part1_topic_id || item.app_oral_practice_question.app_part23_topic_id

    json = {status: 0, contents: item_hash}

    render json: json

  end

  # 获取是否已经给用户评过星星
  # params: id,token
  def is_stared_by_user
    id = params[:id]
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?
    count = AppOralPracticeStar.where(app_oral_practice_comment_id: id, app_user_id: user.id).count
    render json: {status: 0, content: {is_stared: count>0}} and return
  end

  # 搜索用户
  # params:token,page,keyword
  def search_user
    page = params[:page].to_i
    keyword = params[:keyword]
    token = params[:token]
    user = verify_token(token)

    list_hash = AppUser.where('username like ?', "%#{keyword}%").map {|item_user|
      item_hash = {}
      item_hash["practice_count"] = item_user.app_oral_practice_comments.count
      item_hash["fan_count"] = item_user.app_fan_users.count
      item_hash["username"] = item_user.username
      item_hash["user_id"] = item_user.id
      item_hash["usericon"] = generate_user_avatar_url(item_user)
      item_hash["followed_count"] = AppFanUser.where(fan_user_id: item_user.id).count
      item_hash["relationship"] = AppFanUser.get_relationship(user.id, item_user.id)
      item_hash
    }

    render json: {status: 0, contents: list_hash} and return
  end

  private

  # 获取学霸版前number名
  def get_top_star(number, days)

    redis_key = "111121111get_top_star_#{number}_#{days}"
    redis_json = $redis.get(redis_key)
    return JSON.load(redis_json) if !redis_json.blank?

    list = AppOralPracticeStar.select("to_user_id,sum(fluent+vocab+grammar+pronuce) as stars").
        where("created_at > ?", DateTime.now - days.days).
        order("stars desc").limit(number).group("to_user_id")

    top_stars = []
    number = list.length if number > list.length
    number.times {|index|
      top_star_user_id = list[index].to_user_id
      top_star_user = AppUser.find(top_star_user_id)
      top_star = {rank: index+1, from: "cronotab", user_id: top_star_user.id,
                  usericon: generate_user_avatar_url(top_star_user),
                  username: top_star_user.username, stars: list[index]["stars"], relationship: 0}
      top_stars << top_star
    }

    $redis.setex(redis_key, 1.days, top_stars.to_json)
    return top_stars

  end


  # 获取学勤版前number名
  def get_top_practice(number, days)

    redis_key = "11111221get_top_practice_#{number}_#{days}"
    redis_json = $redis.get(redis_key)
    return JSON.load(redis_json) if !redis_json.blank?

    list = AppOralPracticeComment.select("app_user_id,count(app_user_id) as practice_count").
        where("created_at > ?", DateTime.now - days.days).order("practice_count desc").limit(number).group("app_user_id")

    top_practices = []
    number = list.length if number > list.length
    number.times {|index|
      top_practice_user_id = list[index].app_user_id
      top_practice_user = AppUser.find(top_practice_user_id)
      top_practice = {rank: index+1, from: "cronotab", user_id: top_practice_user.id,
                      usericon: generate_user_avatar_url(top_practice_user),
                      username: top_practice_user.username, practices: list[index]["practice_count"],
                      relationship: 0}
      top_practices << top_practice
    }
    $redis.setex(redis_key, 1.days, top_practices.to_json)
    return top_practices

  end

end

class Tab1OralMemory::OralMemoryController < ApplicationController

  def test
    render json: [content: "OralMemoryController"]
  end

  #获取口语回忆列表
  #page,location_id
  #
  def oral_memory_list

    key = "OralMemoryController_oral_memory_list_"
    list = []
    page = params[:page].to_i
    page ||= 1
    location_id = params[:location_id]
    if location_id.blank?
      list = AppOralMemory.where(is_show: true).order(created_at: :desc).page(page).per(5)
    else
      list = AppOralMemory.where(is_show: true, app_exam_location_id: location_id).order(created_at: :desc).page(page).per(5)
    end
    key = key+list.map(&:id).join("_")

    redis_data = $redis.get(key)
    render json: JSON.load(redis_data) and return if !redis_data.blank?

    list = list.map {|item|
      user = item.app_user
      item_hash = item.as_json(only: [:id, :app_user_id, :room_number, :is_old, :part1, :part2, :part3,
                                      :is_new, :part_all, :impression])
      item_hash["usericon"] = generate_user_avatar_url(user)
      item_hash["username"] = user.username
      item_hash["location"] = item.app_exam_location.location
      item_hash["comment_count"] = item.app_oral_memory_comments.count()
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      question_ids = item.app_part23_topic.app_oral_practice_questions.map(&:id)
      practice_count = AppOralPracticeComment.where(app_oral_practice_question_id: question_ids).count
      item_hash["practice_count"] = practice_count
      item_hash
    }
    json = {status: 0, contents: list, message: "获取成功"}
    $redis.setex(key, 60, json.to_json)
    render json: json
    return

  end

  #获取回忆详情
  #params: id
  def oral_memory_detail

    id = params[:id]
    memory = AppOralMemory.find(id)
    content_hash = memory.as_json(only: [:id, :app_user_id, :room_number, :is_old, :part1, :part2, :part3,
                                         :is_new, :part_all, :impression])
    content_hash["usericon"] = generate_user_avatar_url(memory.app_user)
    content_hash["username"] = memory.app_user.username
    content_hash["location"] = memory.app_exam_location.location
    content_hash["comment_count"] = memory.app_oral_memory_comments.count
    question_ids = memory.app_part23_topic.app_oral_practice_questions.map(&:id)
    practice_count = AppOralPracticeComment.where(app_oral_practice_question_id: question_ids).count
    content_hash["practice_count"] = practice_count
    content_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(memory.created_at)
    comments = memory.app_oral_memory_comments.order(created_at: :desc).page(1).per(5)
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
    render json: {status: 0, content: content_hash, comments: comments_hash, message: "获取成功"}
    return
  end

  # 获取口语回忆更多评论
  # params:id,page
  def more_oral_memory_comments
    memory_id = params[:id]
    page = params[:page].to_i
    page ||= 1
    memory = AppOralMemory.find(memory_id)
    comments = memory.app_oral_memory_comments.order('created_at DESC').page(page).per(5)
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

  #获取相关录音
  # params:token,memory_id,page,star_cache
  def recommended_oral_practice_comments

    token = params[:token]
    memory_id = params[:memory_id]
    page = params[:page].to_i
    star_cache = params[:star_cache]

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    questions_ids = AppOralMemory.find(memory_id).app_part23_topic.app_oral_practice_questions.map(&:id)
    comments_list = AppOralPracticeComment.where(is_show: true).where(app_oral_practice_question_id: questions_ids).order(id: :desc).page(page).per(10)
    comments_hash = comments_list.map {|item|
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
      item_hash["question_id"] = item.app_oral_practice_question.id
      item_hash["is_collected"] = AppCollection.get_is_collected(item.id, $COLLECTION_TYPE_ORAL_PRACTICE_COMMENT)
      item_hash["collections"] = AppCollection.get_collection_count(item.id, $COLLECTION_TYPE_ORAL_PRACTICE_COMMENT)
      item_hash["comment_count"] = item.app_oral_practice_comment_comments.count
      item_hash
    }
    json = {status: 0, contents: {comments: comments_hash}}
    render json: json
  end

  #发布口语回忆评论
  #params:id,comment,token   optional:to_user_id,to_comment_id
  def publish_oral_memory_comment
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    comment = params[:comment]
    render json: {status: 2, message: "评论内容不能为空"} and return if comment.blank?

    memory_id = params[:id]
    memory = AppOralMemory.find_by_id(memory_id)
    render json: {status: 3, message: "回忆不存在"} and return if memory.blank?

    to_user_id = params[:to_user_id]
    to_comment_id = params[:to_comment_id]
    newData = AppOralMemoryComment.new(app_oral_memory_id: memory_id, app_user_id: user.id, to_user_id: to_user_id,
                                       content: comment, to_comment_id: to_comment_id)
    if newData.save
      render json: {status: 0, message: "评论成功"} and return
    else
      render json: {status: 0, message: "评论失败"} and return
    end

  end

  #发布回忆
  # params:is_part1_new,is_part23_new,token,part1_ids,part2_id,part1,part2,part3,impression,room_number,exam_date_id,exam_location_id
  def publish_oral_memory

    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "用户登录过期"} and return if user.blank?
    is_part1_new = params[:is_part1_new]
    is_part23_new = params[:is_part23_new]
    part1_ids = params[:part1_ids]
    part2_id = params[:part2_id]
    part1 = params[:part1]
    part2 = params[:part2]
    part3 = params[:part3]
    impression = params[:impression]
    room_number = params[:room_number]
    exam_date_id = params[:exam_date_id]
    exam_location_id = params[:exam_location_id]
    memory = AppOralMemory.new(part1_is_new_state: is_part1_new, part23_is_new_state: is_part23_new,
                               app_part23_topic_id: part2_id, part1: part1, part2: part2, part3: part3, impression: impression,
                               room_number: room_number, app_exam_date_id: exam_date_id, app_exam_location_id: exam_location_id)
    part1_ids = part1_ids.split(",")
    part1_ids.each {|id|
      topic = AppPart1Topic.find(id)
      memory.app_part1_topics << topic
    }
    memory.app_user = user
    memory.is_show = true
    p memory
    if memory.save
      render json: {status: 0, message: "发布成功"} and return
    else
      render json: {status: 1, message: "发布失败"} and return
    end

  end

  # 获取part1的列表
  # days,location_id
  def part1s
    key = "part1_"
    days = params[:days]
    location_id = params[:location_id]
    key += days if !days.blank?
    key += location_id if !location_id.blank?
    render json: JSON.load($redis.get(key)) and return if !$redis.get(key).blank?
    data_hash = AppPart1Topic.all.map {|item|
      {id: item.id, topic: item.topic, total_count: item.get_total_count(days, location_id), url: generate_detailed_link(item)}
    }
    redis_data = {status: 0, contents: data_hash, message: "获取part1成功"}
    p redis_data
    p "重新获取"
    $redis.setex(key, 20, redis_data.to_json)
    render json: redis_data and return
  end

  # 获取part1的列表
  # days,location_id
  def part23s
    key = "part23_"
    days = params[:days]
    location_id = params[:location_id]
    key += days if !days.blank?
    key += location_id if !location_id.blank?
    render json: JSON.load($redis.get(key)) and return if !$redis.get(key).blank?
    data_hash = AppPart23Topic.all.map {|item|
      {id: item.id, topic: item.topic, total_count: item.get_total_count(days, location_id), url: generate_detailed_link(item)}
    }
    redis_data = {status: 0, contents: data_hash, message: "获取part23成功", show_is_new: false}
    p "重新获取"
    $redis.setex(key, 20, redis_data.to_json)
    render json: redis_data and return
  end

  # 工具:生成part1或part23的条目的对应的url
  def generate_detailed_link obj
    if obj.class==AppPart1Topic
      return "http://ieltsbroapplication.hcp.tech:9999/list/part1?id=#{obj.id}"
    end
    return "http://ieltsbroapplication.hcp.tech:9999/list/part23?id=#{obj.id}"
  end

end

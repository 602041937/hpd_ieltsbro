class Tab5::PersonalController < ApplicationController
  # 我的考题
  # params:page,token
  def my_basic_memories
    token = params[:token]
    page = params[:page].to_i

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    list = user.app_oral_memories.where(is_show: true).order(id: :desc).map {|item|
      user = item.app_user
      item_hash = item.as_json(only: [:id, :app_user_id, :room_number, :is_old, :part1, :part2, :part3,
                                      :is_new, :part_all, :impression])
      item_hash["usericon"] = generate_user_avatar_url(user)
      item_hash["username"] = user.username
      item_hash["location"] = item.app_exam_location.location
      item_hash["comment_count"] = item.app_oral_memory_comments.count(1)
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      question_ids = item.app_part23_topic.app_oral_practice_questions.map(&:id)
      practice_count = AppOralPracticeComment.where(app_oral_practice_question_id: question_ids).count
      item_hash["practice_count"] = practice_count
      item_hash
    }
    json = {status: 0, contents: list, message: "获取成功"}
    render json: json
    return
  end

  #获取我的练习列表
  #params:token,page
  def my_oral_practice

    token = params[:token]
    page = params[:page].to_i

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    # where("")能忽略
    #AppOralPracticeComment.where(is_show: true).order(id: :desc).joins(:app_user).where("")
    comments_list = user.app_oral_practice_comments.where(is_show: true).order(id: :desc).page(page).per(10)
    comments_hash = comments_list.map {|item|
      item_hash = item.as_json(only: [:id, :seconds])
      # item_hash["fluent"] = 10
      item_hash["audio_record"] = generate_user_oral_practice_comment_url(item)
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      # item_hash["vocab"] = 10
      item_hash["user_id"] = item.app_user_id
      item_hash["is_stared"] =
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
    json = {status: 0, contents: comments_hash}
    render json: json

  end

  # 获取我的考圈列表接口
  # params:token,page,rel_cache,star_cache,collection_type
  def my_exam_group


    token = params[:token]
    page = params[:page].to_i

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    # where("")能忽略
    #AppOralPracticeComment.where(is_show: true).order(id: :desc).joins(:app_user).where("")

    user_ids = AppFanUser.where(fan_user_id: user.id).map(&:app_user_id)
    comments_list = AppOralPracticeComment.where(is_show: true).where(app_user_id: user_ids).order(id: :desc).page(page).per(10)
    comments_hash = comments_list.map {|item|
      item_hash = item.as_json(only: [:id, :seconds])
      # item_hash["fluent"] = 10
      item_hash["audio_record"] = generate_user_oral_practice_comment_url(item)
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      # item_hash["vocab"] = 10
      item_hash["user_id"] = item.app_user_id
      item_hash["is_stared"] =
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

    json = {status: 0, contents: comments_hash}
    render json: json
  end

  # 获取我的收藏
  # params:page,token
  def get_collection
    token = params[:token]
    page = params[:page].to_i

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?
    contents_hash = user.app_collections.map {|item|
      item_hash = item.as_json
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      item_hash["message"] = ""
      if item.collection_type== $COLLECTION_TYPE_WRITING_USER_CONTENT
        item_hash["message"]="我收藏了<font color='#55CEF8'>#{AppUser.find(AppWritingUserContent.find_by_id(item.item_id).app_user_id).username}</font>的写作练习"
      elsif item.collection_type==$COLLECTION_TYPE_VIDEO
        item_hash["message"]="我收藏了视频<font color='#55CEF8'>#{AppVideo.find_by_id(item.item_id).name}</font>"
      elsif item.collection_type==$COLLECTION_TYPE_ORAL_PRACTICE_COMMENT
        item_hash["message"]="我收藏了<font color='#55CEF8'>#{AppOralPracticeComment.find_by_id(item.item_id).app_user.username}</font>的口语练习"
      elsif item.collection_type==$COLLECTION_TYPE_PART1_TOPIC_QUESTION
        item_hash["message"]="我收藏了Part 1的口语题卡：<font color='#55CEF8'>#{AppPart1Topic.find_by_id(item.item_id).topic}</font>"
      elsif item.collection_type==$COLLECTION_TYPE_PART23_TOPIC_QUESTION
        item_hash["message"]="我收藏了Part 23的口语题卡：<font color='#55CEF8'>#{AppPart23Topic.find_by_id(item.item_id).topic}</font>"
      elsif item.collection_type==$COLLECTION_TYPE_ORAL_MEMORY
        item_hash["message"]="我收藏了<font color='#55CEF8'>#{AppOralMemory.find_by_id(item.item_id).app_user.username}</font>的口语回忆"
      elsif item.collection_type==$COLLECTION_TYPE_WRITTEN_MEMORY
        item_hash["message"]="我收藏了<font color='#55CEF8'>#{AppWrittenMemory.find_by_id(item.item_id).app_user.username}</font>的笔试回忆"
      elsif item.collection_type=="article"
        item_hash["message"]="我收藏了图文推送<font color='#55CEF8'>#{AppArticle.find_by_id(item.item_id).title}</font>"
      end
      item_hash
    }
    render json: {status: 0, contents: contents_hash}
  end

  # 更换手机号
  # token,mobile,code,zone,device,deviceid,verify_mobile_provider
  def change_mobile
    mobile = params[:mobile]
    zone = params[:zone]
    token = params[:token]
    code = params[:code]

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    mobile = HPDEncryptionUtils.hpd_rsa_decode_by_string(mobile)
    user.mobile = mobile
    if user.save
      render json: {status: 0, message: "手机号修改成功"} and return
    end
    render json: {status: 1, message: "手机号修改失败"} and return
  end


end

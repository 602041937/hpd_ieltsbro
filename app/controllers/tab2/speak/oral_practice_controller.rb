class Tab2::Speak::OralPracticeController < ApplicationController

  #获取口语首页的part1/part23的列表
  #params:part(1|2),type(|)
  def oral_list
    part = params[:part].to_i
    type = params[:type]
    redis_key = "oral_list_" + part.to_s + "_" +type
    p redis_key
    redis_json = $redis.get(redis_key)
    render json: eval(redis_json) and return if !redis_json.blank?
    list = {}
    if part==1
      list = AppOralPracticePart1Category.where(name: type).last.app_part1_topics
      collection_type = "part1_topic_question"
    elsif part==2
      list = AppOralPracticePart23Category.where(name: type).last.app_part23_topics
      collection_type = "part23_topic_question"
    end
    index = 0
    list_hash = list.map {|item|
      index += 1
      item_hash = item.as_json(only: [:id, :tags, :is_sleep])
      item_hash["description"] = item.content
      comments_count = 0
      item.app_oral_practice_questions.each {|question|
        comments_count += question.app_oral_practice_comments.count
        comments_count
      }
      item_hash["comments"] =comments_count
      item_hash["topic"] = "<b>#{index}.</b>#{item.topic}"
      item_hash["tags"] = "tag"
      item_hash["collections"] = AppCollection.get_collection_count(item.id, collection_type)
      item_hash["part"] = part
      item_hash["type"] = type
      item_hash["is_sleep"] = 0
      item_hash
    }
    json = {status: 0, contents: list_hash}
    $redis.setex(redis_key, 10, json)
    render json: json
  end

  # 获取题目列表（一个topic下的所有题目）
  # params:token,part,id
  def question_list

    token = params[:token]
    part = params[:part].to_i
    topic_id = params[:id]
    if token.blank? || part.blank? || topic_id.blank?
      render json: {status: 1, message: "参数不全"} and return
    end

    user = verify_token(token)
    render json: {status: 104, message: "用户无效"} and return if user.blank?
    redis_key = "question_list_#{part}_#{topic_id}"
    redis_json = $redis.get(redis_key)
    render json: eval(redis_json) and return if !redis_json.blank?

    if part==1
      question_list = AppPart1Topic.find_by_id(topic_id).app_oral_practice_questions.where(is_show: true).order(:question_order)
    elsif part==2
      question_list = AppPart23Topic.find_by_id(topic_id).app_oral_practice_questions.where(is_show: true).order(:question_order)
    end

    p question_list.count
    question_hash = question_list.map {|item|
      item_hash = item.as_json(only: [:id, :topic, :description, :vu, :uu])
      item_hash["comment_count"] = item.app_oral_practice_comments.count
      item_hash
    }
    json = {status: 0, is_collected: false, contents: question_hash, message: "获取成功"}
    $redis.setex(redis_key, 10, json)
    render json: json and return

  end

  # topic题目列表单个题目所对应的录音列表
  # params:token,page,id
  def oral_detail_comments

    token = params[:token]
    page =params[:page].to_i
    question_id = params[:id]
    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?
    question = AppOralPracticeQuestion.find_by_id(question_id)
    render json: {status: 1, message: "该topic没有对应的题目"} and return if question.blank?
    redis_key = "oral_detail_comments_#{question_id}_#{page}"
    redis_json = $redis.get(redis_key)
    render json: eval(redis_json) and return if !redis_json.blank?
    p "page=#{page}"
    if page == 1
      list = question.app_oral_practice_comments.where('is_show = true').order('seconds DESC').limit(8)
    else
      #.limit(5).offset(5*(page-1)+3)
      list = question.app_oral_practice_comments.where('is_show = true').order('seconds DESC').limit(5).offset(5*(page-1)+3)
    end
    comments_hash = list.map {|item|
      item_hash = item.as_json(only: [:id, :seconds])

      # item_hash["fluent"] = 10
      item_hash["audio_record"] = generate_user_oral_practice_comment_url(item)
      item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      # item_hash["vocab"] = 10
      item_hash["user_id"] = item.app_user_id
      item_hash["is_stared"] = AppOralPracticeStar.get_is_stared(user.id, item.id)
      item_hash["avatar"] = generate_user_avatar_url(item.app_user)
      # item_hash["grammar"] = 10
      item_hash["stars"] = AppOralPracticeStar.where(app_oral_practice_comment_id: item.id).sum("fluent+grammar+pronuce+vocab")
      # item_hash["pronuce"] = 10
      item_hash["username"] = item.app_user.username
      item_hash
    }
    tops = []
    comments = []
    if page ==1
      tops = comments_hash[0..2]
      # 如果comments_hash.length-1比3小，就会抛出nil
      comments = comments_hash[3..comments_hash.length-1] ||= []
    else
      tops = []
      comments = comments_hash
    end
    json = {status: 0, contents: {tops: tops, comments: comments}, message: "获取成功"}
    $redis.setex(redis_key, 10, json)
    render json: json and return
  end


  # topic题目列表单个题目所对应的答案列表
  # params:token,page,id
  def oral_detail_answers

    token = params[:token]
    page =params[:page].to_i
    question_id = params[:id]
    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?
    question = AppOralPracticeQuestion.find_by_id(question_id)
    render json: {status: 1, message: "该topic没有对应的题目"} and return if question.blank?
    redis_key = "oral_detail_answers_#{question_id}_#{page}"
    redis_json = $redis.get(redis_key)
    render json: eval(redis_json) and return if !redis_json.blank?
    answers = question.app_oral_practice_sample_answers.where('is_show = true').order('created_at DESC').page(page).per(5)
    answers_hash = answers.map {|item|
      item_hash = item.as_json(only: [:id, :content, :is_default])
      # item_hash["created_at"] = HPDTimeUtils.hpd_dateTimeToYmdHM(item.created_at)
      item_hash['username'] = item.app_user.username
      item_hash
    }
    json = {status: 0, contents: {answers: answers_hash}, message: "获取成功"}
    $redis.setex(redis_key, 10, json)
    render json: json and return
  end


  # 发布语音接口
  # parmas: token,id,seconds,audio_file(FILE)
  def publish_oral_practice_comment

    token = params[:token]
    question_id = params[:id]
    seconds = params[:seconds]
    audio_file = params[:audio_file]
    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?
    question = AppOralPracticeQuestion.find_by_id(question_id)
    render json: {status: 1, message: "该topic没有对应的题目"} and return if question.blank?

    comment = AppOralPracticeComment.new
    comment.app_user = user
    comment.app_oral_practice_question = question
    comment.seconds = seconds
    comment.play_times = 1
    comment.audio_record = audio_file

    if comment.save
      p generate_user_oral_practice_comment_url(comment)
      render json: {status: 0, message: "等待审核", id: comment.id, audio: generate_user_oral_practice_comment_url(comment)}
      return
    end
    render json: {status: 1, message: "上传失败"}
    return
  end

  #发布口语分享答案
  #params: id,token,content
  def publish_oral_detail_answer
    question_id = params[:id]
    token = params[:token]
    content = params[:content]
    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?
    question = AppOralPracticeQuestion.find_by_id(question_id)
    render json: {status: 1, message: "该topic没有对应的题目"} and return if question.blank?
    item = question.app_oral_practice_sample_answers.new
    item.app_user = user
    item.content = content
    if item.save
      render json: {status: 0, message: "分享答案成功"} and return
    end
    render json: {status: 1, message: "分享答案失败"} and return
  end

  #查询口语练习
  #page,keyword
  def search_oral_practice
    keyword = params[:keyword]
    render json: {status: 1, message: "关键字不能为空"} and return if keyword.blank?
    redis_key = "search_oral_practice_"+keyword
    redis_json = $redis.get(redis_key)
    render json: eval(redis_json) and return if !redis_json.blank?
    list = AppPart1Topic.where('LOWER(topic) like ? or LOWER(oral_practice_description) like ?', "%#{keyword}%", "%#{keyword}%")
    list_hash = list.map {|item|
      item_hash = item.as_json(only: [:id, :tags, :is_sleep])
      item_hash["description"] = item.content
      comments_count = 0
      item.app_oral_practice_questions.each {|question|
        comments_count += question.app_oral_practice_comments.count
        comments_count
      }
      item_hash["comments"] =comments_count
      item_hash["topic"] = item.topic
      item_hash["tags"] = "tag"
      item_hash["collections"] = 0
      item_hash["part"] = 1
      item_hash["type"] = item.app_oral_practice_part1_category.name
      item_hash["is_sleep"] = 0
      item_hash
    }

    list23 = AppPart23Topic.where('LOWER(topic) like ? or LOWER(oral_practice_description) like ?', "%#{keyword}%", "%#{keyword}%")
    list_hash += list23.map {|item|
      item_hash = item.as_json(only: [:id, :tags, :is_sleep])
      item_hash["description"] = item.content
      comments_count = 0
      item.app_oral_practice_questions.each {|question|
        comments_count += question.app_oral_practice_comments.count
        comments_count
      }
      item_hash["comments"] =comments_count
      item_hash["topic"] = item.topic
      item_hash["tags"] = "tag"
      item_hash["collections"] = 0
      item_hash["part"] = 2
      item_hash["type"] = item.app_oral_practice_part23_category.name
      item_hash["is_sleep"] = 0
      item_hash
    }
    json = {status: 0, contents: list_hash}
    p json
    $redis.setex(redis_key, 10, json)
    render json: json
  end

  # 给口语练习打分
  # params:id,token,fluent,vocab,grammar,pronuce
  def give_stars_to_oral_practice_comment

    comment_id = params[:id]
    token = params[:token]
    fluent = params[:fluent].to_i
    vocab = params[:vocab].to_i
    grammar = params[:grammar].to_i
    pronuce = params[:pronuce].to_i

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    comment = AppOralPracticeComment.find(comment_id)
    if comment.app_user.id == user.id
      render json: {status: 1, message: "不能给自己评星"} and return
    end

    is_stared = AppOralPracticeStar.get_is_stared(user.id, comment.id)
    render json: {status: 2, message: "已经评过星"} and return if is_stared

    new_item = AppOralPracticeStar.new(app_user_id: user.id, app_oral_practice_comment_id: comment.id,
                                       fluent: fluent, vocab: vocab, grammar: grammar, pronuce: pronuce,
                                       to_user_id: comment.app_user.id)
    if new_item.save
      render json: {status: 0, message: "评星成功"} and return
    end
    render json: {status: 3, message: "评星失败"} and return
  end


end

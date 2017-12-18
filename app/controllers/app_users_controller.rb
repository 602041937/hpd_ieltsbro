class AppUsersController < ApplicationController

  include ApplicationHelper

=begin

用户注册

request params:
username,password,mobile  => 加密的
device,app_exam_date_id,app_exam_location_id,verify_code,zone,push_token,
device_uid,device_name, app_version,system_version, verify_mobile_provider, deviceid

=end
  def register
    #todo
    username = params[:username]
    password = params[:password]
    mobile = params[:mobile]
    zone = params[:zone]
    app_exam_date_id = params[:app_exam_date_id]
    app_exam_location_id = params[:app_exam_location_id]
    if username.blank? || password.blank? || mobile.blank? || zone.blank?
      render json: {status: -1, message: "信息不全"}
    end

    new_user = AppUser.new
    new_user.username = HPDEncryptionUtils.hpd_rsa_decode_by_string(username)
    raw_password = HPDEncryptionUtils.hpd_rsa_decode_by_string(password)
    new_user.password = HPDEncryptionUtils.hpd_md5(raw_password)
    new_user.mobile = HPDEncryptionUtils.hpd_rsa_decode_by_string(mobile)
    new_user.zone = zone
    new_user.app_exam_date_id = app_exam_date_id
    new_user.app_exam_location_id = app_exam_location_id
    p app_exam_date_id
    if new_user.save
      user_hash = new_user.as_json(only: [:id, :username, :mobile, :zone, :app_exam_date_id, :app_exam_location_id])
      token = generate_token(new_user.id)
      if token.blank?
        new_user.destroy
        render json: {status: -2, message: "服务端错误"}
        return
      end
      render json: {status: 0, token: token, user: user_hash, message: "注册成功"}
      return
    end
    p new_user.errors
    render json: {status: 1, message: "注册失败"}
    return
  end

  def logout
    token = params[:token]
    current_user =verify_token(token)
    if current_user==nil
      render json: {status: 104, message: "登出失败"}
      return
    end
    render json: {status: 0, mesasge: "登出成功"}
    return

  end

  # request: push_token,device,device_uid,password,mobile,zone,device_name,app_version,system_version
  def login
    begin
      push_token = params[:push_token]
      device = params[:device]
      device_uid = params[:device_uid]
      password = params[:password]
      mobile = params[:mobile]
      zone = params[:zone]
      device_name = params[:device_name]
      app_version = params[:app_version]
      system_version = params[:system_version]

      if password.blank? || mobile.blank? || zone.blank?
        render json: {status: -1, message: "信息不全"}
        return
      end

      raw_password = HPDEncryptionUtils.hpd_rsa_decode_by_string(password)
      md5_password = HPDEncryptionUtils.hpd_md5(raw_password)
      raw_mobile = HPDEncryptionUtils.hpd_rsa_decode_by_string(mobile)
      user = AppUser.where(password: md5_password, mobile: raw_mobile, zone: zone).last
      if user == nil
        render json: {status: 1, message: "用户名或者密码错误"}
        return
      end
      token = generate_token(user.id)
      if token.blank?
        render json: {status: -2, message: "服务端错误"}
        return
      end
      user_hash = user.as_json(only: [:id, :username, :mobile, :zone, :app_exam_date_id, :app_exam_location_id, :sex, :current_location])
      user_hash[:user_icon] = generate_user_avatar_url(user)
      user_hash[:app_destination_country_id] = user.app_destination_id

      render json: {status: 0, token: token, user: user_hash}
      return

    rescue => e
      p e.message
    end
    render json: {status: 1, message: "用户名或者密码错误"}
    return
  end

  # 上传头像
  def upload_avatar
    avatar = params[:avatar]
    token = params[:token]
    user = verify_token(token)
    if user==nil
      render json: {status: 104, message: "无效"}
      return
    end
    # !!! 这句在数据中存储的是文件名：例如：20171026_204107_crop.jpg
    user.avatar = avatar
    if user.save
      render json: {status: 0, usericon: generate_user_avatar_url(user), message: "头像上传成功"}
      return
    end
    render json: {status: 1, message: "头像上传失败"}
  end

  #更新用户头像和用户名
  #token,username
  def update_avatar_and_username
    token = params[:token]
    username =params[:username]
    avatar = params[:avatar]
    user = verify_token(token)
    if user==nil
      render json: {status: 104, message: "无效"}
      return
    end
    user.username = username if !username.blank?
    user.avatar = avatar if !avatar.blank?
    if user.save
      render json: {status: 0, usericon: generate_user_avatar_url(user), username: user.username}
      return
    end
    render json: {status: 1, message: "修改失败"}
    return
  end

  #生成token
  def generate_token(user_id)
    user = AppUser.find_by_id(user_id)
    return nil if user == nil
    token = HPDEncryptionUtils.hpd_rsa_encode_by_string("#{user_id}===!!!===#{Time.now}")
    user.token = token
    user.save
    return token

  end


  #验证用户名
  #username
  def validate_user_name
    if AppUser.find_by(username: params[:username])
      render json: {status: 0, content: {used: true}}
      return
    end
    render json: {status: 0, content: {used: false}}
    return
  end

  # 目标用户主页
  # params: target_id,token,rel_cache
  def target_user_details

    token = params[:token]
    target_id = params[:target_id]
    rel_cache = params[:rel_cache]

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    target_user = AppUser.find(target_id)

    practice_count = target_user.app_oral_practice_comments.count
    fan_count = target_user.app_fan_users.count
    followed_count = AppFanUser.where(fan_user_id: target_user.id).count
    relationship = AppFanUser.get_relationship(user.id, target_id)

    json = {status: 0, practice_count: practice_count, fan_count: fan_count, followed_count: followed_count,
            contents: {username: target_user.username, usericon_hd: generate_user_avatar_url(target_user),
                       usericon: generate_user_avatar_url(target_user), id: target_user.id, relationship: relationship}}
    render json: json and return

  end

  # 获取用户主页的练习列表
  # params: target_id,token,page，star_cache，collection_type
  def target_user_details_oral_practices

    token = params[:token]
    page = params[:page].to_i
    target_id = params[:target_id]
    star_cache = params[:star_cache]
    collection_type = params[:collection_type]

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    target_user = AppUser.find(target_id)

    comments_list = target_user.app_oral_practice_comments.where(is_show: true).order(id: :desc).page(page).per(5)
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
    json = {status: 0, contents: comments_hash}
    render json: json
  end

  # 获取用户主页的关注列表
  # params: target_id,token,page，star_cache，collection_type
  def target_user_details_followed

    token = params[:token]
    page = params[:page].to_i
    target_id = params[:target_id]
    star_cache = params[:star_cache]
    collection_type = params[:collection_type]

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    target_user = AppUser.find(target_id)

    list_hash = AppFanUser.where(fan_user_id: target_user.id).map {|item|
      item_user = AppUser.find(item.app_user_id)
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

    json = {status: 0, contents: list_hash}
    render json: json and return
  end


  # 获取用户主页的粉丝列表
  # params: target_id,token,page，star_cache，collection_type
  def target_user_details_fans

    token = params[:token]
    page = params[:page].to_i
    target_id = params[:target_id]
    star_cache = params[:star_cache]
    collection_type = params[:collection_type]

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    target_user = AppUser.find(target_id)

    list_hash = target_user.app_fan_users.map {|item|
      item_user = AppUser.find(item.fan_user_id)
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

    json = {status: 0, contents: list_hash}
    render json: json and return
  end

  # 获取我与用户的关系
  # params: token,target_user_id
  def relationship_to_user

    token = params[:token]
    target_id = params[:target_user_id].to_i

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    render json: {status: 0, content: {relationship: AppFanUser.get_relationship(user.id, target_id)}} and return
  end

  # 关注用户
  # params:token,target_id
  def add_me_as_fan_to
    token = params[:token]
    target_id = params[:target_id].to_i

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    target_user = AppUser.find(target_id)
    count = AppFanUser.where(app_user_id: target_id, fan_user_id: user.id).count
    render json: {status: 0, message: "已经关注", relationship: AppFanUser.get_relationship(user.id, target_id)} and return if count > 0

    new_item = AppFanUser.new(app_user_id: target_id, fan_user_id: user.id)
    if new_item.save
      render json: {status: 0, message: "关注成功", relationship: AppFanUser.get_relationship(user.id, target_id)} and return
    end

    render json: {status: 0, message: "关注失败"} and return

  end

  # 取消关注
  # params:token,target_id
  def remove_me_from_fan_list_of

    token = params[:token]
    target_id = params[:target_id].to_i

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    target_user = AppUser.find(target_id)
    items = AppFanUser.where(app_user_id: target_id, fan_user_id: user.id)
    if items.destroy_all
      render json: {status: 0, message: "已经关注", relationship: AppFanUser.get_relationship(user.id, target_id)} and return
    end
    render json: {status: 0, message: "取消关注失败"} and return
  end

  #更新个人资料
  #params:token,sex,current_location,date_id,location_id,app_destination_id
  def update_profile

    token = params[:token]
    sex = params[:sex].to_i
    current_location = params[:current_location]
    date_id = params[:date_id].to_i
    location_id = params[:location_id].to_i
    app_destination_id = params[:app_destination_id].to_i

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    user.sex = sex if !sex.blank?
    user.current_location = current_location if !current_location.blank?
    user.app_exam_date_id = date_id if !date_id.blank?
    user.app_exam_location_id = location_id if !location_id.blank?
    user.app_destination_id = app_destination_id if !app_destination_id.blank?

    if user.save
      render json: {status: 0, message: "更新成功"} and return
    end
    render json: {status: 0, message: "更新失败"} and return
  end

  # 我的界面信息
  # params:token
  def my_profile_basic_info

    token = params[:token]

    user = verify_token(token)
    render json: {status: 104, message: "无效"} and return if user.blank?

    contents = {}
    contents["article_id"] = 0
    contents["article_title"] = ""
    contents["collection_count"] = user.app_collections.count
    contents["days"] = "雅思哥已经陪伴你<font color='#55cef8'>#{((Time.now - user.created_at)/60/60/24).to_i}</font>天了"
    lastest_group_user = nil
    lastest_group_comment = nil
    AppFanUser.where(fan_user_id: user.id).each {|item|
      item_user = AppUser.find(item.app_user_id)
      item_comment = item_user.app_oral_practice_comments.order(created_at: :desc).first
      if !item_comment.blank?
        if !lastest_group_comment.blank?
          lastest_group_comment = item_comment and lastest_group_user=item_user if item_comment.created_at > lastest_group_comment.created_at
        else
          lastest_group_comment = item_comment and lastest_group_user=item_user
        end
      end
    }
    if !lastest_group_comment.blank?
      contents["lastest_group_icon"] = generate_user_avatar_url(lastest_group_user)
      contents["lastest_group_id"] = lastest_group_comment.id
      contents["my_fan_count"] = lastest_group_user.app_fan_users.count
      contents["my_followed_count"] = AppFanUser.where(fan_user_id: lastest_group_user.id).count
      contents["name_update_count"] = 0
    end

    p contents

    render json: {status: 0, contents: contents}

  end


  def test
    content = <<-HPD
      {"name":"hpd"}
    HPD
    tokens = ["807490c1b2263e104acd45186c369035"]
    #send_slient_message(content, tokens)
    #broadcast_slient_message(content)
    #send_notification_message("hpdtitle2", "hpdbody2", content, tokens)
    broadcast_notification_message("hpdtitl2e", "hpdbod2y", tokens)
    return render json: content
  end

end

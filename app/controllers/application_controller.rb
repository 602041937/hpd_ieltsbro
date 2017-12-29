class ApplicationController < ActionController::Base

  #因为请求API时，会报ActionController::InvalidAuthenticityToken的错误，这个
  #是用于防止csrf攻击的，为了解决错误，这行注释
  #protect_from_forgery with: :exception

  def hpd_hehe
    return "hpd_hehe"
  end


  # 生成用户头像地址url
  def generate_user_avatar_url(user)

    # 使用本地的图片
    # if user.avatar.blank?
    #   return "http://#{request.host_with_port}/app_user/avatar/#{user.id}/user_default"
    # else
    #   return "http://#{request.host_with_port}/app_user/avatar/#{user.id}/#{HPDEncryptionUtils.hpd_md5(user.avatar_identifier)}"
    # end

    # 使用阿里云的oss的图片
    return user.avatar.url
  end

  # 生成用户语音评论地址url
  def generate_user_oral_practice_comment_url(comment)
    # 使用本地存储
    return "http://#{request.host_with_port}/app_user/oral_practice_question_comments/#{comment.id}"

    #使用阿里云的oss存储
    return comment.audio_record.url
  end

  @@user_cache={}
  @@id_token={}
  #验证token,如果验证失败就返回nil，验证成功就返回
  def verify_token(token)
    return nil if token.blank?
    if @@user_cache[token] != nil && @@user_cache[token][1]> Time.now
      return @@user_cache[token][0]
    end
    raw_token = HPDEncryptionUtils.hpd_rsa_decode_by_string(token)
    split = raw_token.split("===!!!===")
    return nil if split.length < 2
    user_id = split[0]
    user_date = split[1]
    return nil if (user_date.to_datetime+5.days)< Time.now
    user = AppUser.find(user_id)
    return nil if user == nil
    older_token = @@id_token[user_id]
    @@user_cache[older_token] = nil
    @@user_cache[token] = [user, Time.now+5.minutes]
    @@id_token[user_id] = token
    return user
  end


  $FIRST_NAME = "HPD"

end

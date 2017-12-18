class Common::CommonController < ApplicationController

  def exam_dates

    list = AppExamDate.where("date > '#{DateTime.now-20.months}'").order(:date)
    list = list.map {|item|
      {id: item.id, content: "#{item.date.year}年#{item.date.month}月#{item.date.day}日", date: item.date}
    }
    render json: {status: 0, contents: list, message: "获取成功"}
  end

  def cities

    list = AppExamCity.all.map {|item|
      {id: item.id, content: item.city}
    }
    render json: {status: 0, contents: list}
  end

  def locations

    list = AppExamLocation.all.map {|item|
      {id: item.id, content: item.location, city_id: item.app_exam_city_id}
    }
    render json: {status: 0, contents: list}
  end

  def destination_countries
    list = AppDestinationCountry.all.map {|item|
      {id: item.id, name: item.name}
    }
    render json: {status: 0, contents: list}
  end


  # 举报
  # params:report_type
  # params:item_id,token
  def report
    report_type = params[:report_type]
    item_id = params[:item_id]
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "用户无效"} and return if user.blank?
    is_report = get_is_reported(report_type, user.id, item_id)
    render json: {status: 0, message: "举报成功"} and return if is_report
    new_item = AppUserReport.new(report_type: report_type, item_id: item_id, app_user_id: user.id)
    if new_item.save
      render json: {status: 0, message: "举报成功"} and return
    end
    render json: {status: 1, message: "举报失败"} and return
  end


  # 返回用户头像
  def user_avatar
    id = params[:id]
    avatar = params[:avatar]
    user = AppUser.where(id: id).last
    if user==nil || avatar == "user_default"
      p "-------"
      path = "#{Rails.root}/public/uploads/app_user/avatar/default_user_icon.png"
    else
      # user.avatar = /uploads/app_user/avatar/46/da_1509356355185_crop.jpeg
      path = "#{Rails.root}/public#{user.avatar}"
    end
    data = File.read(path)
    send_data(data, type: "image", disposition: "inline")
  end

  # 返回用户语音评论
  def get_user_oral_practice_question_comments
    id = params[:id]
    comment = AppOralPracticeComment.where(id: id).last
    path = "#{Rails.root}/public#{comment.audio_record}"
    data = File.read(path)
    send_data(data, type: "mp3", disposition: "inline")
  end


  private
  def get_is_reported(report_type, app_user_id, item_id)
    count = AppUserReport.where(report_type: report_type, app_user_id: app_user_id, item_id: item_id).count
    return count>0
  end

end

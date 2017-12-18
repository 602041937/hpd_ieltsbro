#工具
class AppUtilitiesController < ApplicationController

  #获取验证码
  #deviceid,mobile,zone, reason
  def send_verify_code
    #todo:现在只是模拟数据
    render json: {status: 0, message: "验证码发送成功"}
  end


end

require 'rest-client'
require 'digest'
require 'json'

#message 为透传内容
module ApplicationHelper

  # GETUI_APP_KEY = "6rSxAmyvEZ53OZtSwOGJp3"
  # GETUI_APP_ID = "emcguJE1Nj64t6SLVCZcu7"
  # GETUI_MASTERSECRET = "Pvw2bjmTLkANjnuE7IMdi1"

  GETUI_APP_KEY = "uKROFQ3Enb54vl3QY9Nro6"
  GETUI_APP_ID = "6bEuG8UoY96WhFZ0Ebxpl5"
  GETUI_MASTERSECRET = "h7XobXKt8Z9iRajlc9o4M2"



  def remove_from_collections type, item_id
    AppCollection.where(collection_type: type, item_id: item_id).destroy_all
  end

  # 获取个推的auth_token，默认的有限期是一天
  def get_getui_auth_token

    begin
      key = "app_getui_auth_token11133"
      auth_token = $redis.get(key)
      p auth_token
      p "有auth_token"
      return auth_token if !auth_token.blank?
      p "没有auth_token"
      timestamp = (Time.now.to_f * 1000).to_i.to_s
      sign = Digest::SHA256.hexdigest("#{GETUI_APP_KEY}#{timestamp}#{GETUI_MASTERSECRET}")

      curl_data = <<-CURL
      curl -H "Content-Type: application/json" \
      https://restapi.getui.com/v1/#{GETUI_APP_ID}/auth_sign \
      -XPOST -d '{ "sign":"#{sign}",
      "timestamp":"#{timestamp}",
      "appkey":"#{GETUI_APP_KEY}"}'
      CURL
      # %x是同步的
      response =%x{#{curl_data}}
      auth_token = JSON.load(response).symbolize_keys[:auth_token]
      $redis.setex(key, 1.days-100, auth_token)
    rescue
      logger.fatal("ApplicationHelper#get_getui_auth_token=>没有开启redis或获取个推auth_token失败")
    end
    return auth_token
  end

  def send_slient_message content, users

    #tokens=users.map {|x| x.push_token if x.pushable==true}.compact.uniq
    tokens = ["982ea04c4461992ed12e71677727fca7"]
    # 旧代码
    # tokens.each_slice(999).each do |t|
    #
    #   RestClient.post("http://182.92.72.30:9000/send_silent_message", {content: content, users: t.join(",")})
    #
    # end

    #new 通过tolist群推
    begin
      curl_data = <<-CURL
      curl -H "Content-Type: application/json" \
       -H "authtoken:  #{get_getui_auth_token}"  \
      https://restapi.getui.com/v1/#{GETUI_APP_ID}/save_list_body \
      -XPOST -d '{
                 "message":{
                    "appkey":"#{GETUI_APP_KEY}",
                    "is_offline":false,
                    "msgtype":"transmission"
                  },
                  "transmission":{
                        "transmission_type":false,
                        "transmission_content":"#{content}"
                  }
                 }
             }'
      CURL
      p "=="
      p curl_data
      response = %x{#{curl_data}}
      task_id = JSON.load(response).symbolize_keys[:taskid]

      tokens.each_slice(999).each do |t|
        curl_data = <<-CURL
        curl -H "Content-Type: application/json" \
         -H "authtoken: #{get_getui_auth_token}" \
         https://restapi.getui.com/v1/#{GETUI_APP_ID}/push_list  \
         -XPOST -d '{
                    "cid":#{t},
                    "taskid":"#{task_id}",
                    "need_detail":true
                    }'
        CURL
        response = system(curl_data)
      end
    rescue
      logger.fatal("ApplicationHelper#send_slient_message=>失败")
    end


    #new 通过单推
    # begin
    #
    #   tokens.each do |item|
    #     curl_data = <<-CURL
    #     curl -H "Content-Type: application/json" \
    #          -H "authtoken:#{get_getui_auth_token}" \
    #          https://restapi.getui.com/v1/#{GETUI_APP_ID}/push_single \
    #          -XPOST -d '{
    #                         "message":{
    #                             "appkey":"#{GETUI_APP_KEY}",
    #                             "is_offline":false,
    #                             "msgtype":"transmission"
    #                         },
    #                         "transmission":{
    #                             "transmission_type":false,
    #                             "transmission_content":"#{content}"
    #                         },
    #                         "push_info": {
    #                             "aps": {
    #                                 "alert": {
    #                                     "title": "hha",
    #                                     "body": "dfafa"
    #                                 },
    #                                 "autoBadge": "+1",
    #                                 "content-available": 1
    #                             }
    #                         },
    #                         "cid":"#{item}",
    #                         "requestid":"#{(Time.now.to_f*1000).to_i}"
    #                      }'
    #     CURL
    #     system(curl_data)
    #   end
    # rescue
    #   logger.fatal("ApplicationHelper#send_slient_message=>失败")
    # end

  end


  def broadcast_slient_message content
    #旧代码
    #RestClient.post("http://182.92.72.30:9000/send_silent_message", {content: content, users: "all"})

    #new
    begin
      curl_data = <<-CURL
      curl -H "Content-Type: application/json" \
           -H "authtoken:#{get_getui_auth_token}" \
           https://restapi.getui.com/v1/#{GETUI_APP_ID}/push_app \
           -XPOST -d '{
                          "message":{
                              "appkey":"#{GETUI_APP_KEY}",
                              "is_offline":false,
                              "msgtype":"transmission"
                          },
                          "transmission":{
                              "transmission_type":false,
                              "transmission_content":"#{content}"
                          },
                          "requestid":"#{(Time.now.to_f*1000).to_i}"
                       }'
      CURL
      system(curl_data)
    rescue
      logger.fatal("ApplicationHelper#broadcast_slient_message=>失败")
    end
  end

  def send_notification_message title, body, content, users
    #tokens=users.map {|x| x.push_token if x.pushable==true}.compact.uniq
    # 旧代码
    # tokens.each_slice(999).each do |t|
    #   RestClient.post("http://182.92.72.30:9000/send_notification_message", {title: title, body: body, content: content, users: t.join(","), action_loc_key: "解锁雅思哥"})
    # end
    tokens = ["35335c1e36bda9b971f5e1bb91565661","",""]
    #new,通过tolist群推
    begin
      curl_data = <<-CURL
      curl -H "Content-Type: application/json" \
           -H "authtoken: #{get_getui_auth_token}"  \
           https://restapi.getui.com/v1/#{GETUI_APP_ID}/save_list_body \
           -XPOST -d '{
                 "message": {
                       "appkey": "#{GETUI_APP_KEY}",
                       "is_offline": true,
                       "offline_expire_time":10000000,
                       "msgtype": "notification"
                    },
                    "notification": {
                        "style": {
                            "type": 0,
                            "text": "#{body}",
                            "title": "#{title}"
                        },
                        "transmission_type": true,
                        "transmission_content": "#{content}"
                    },
                    "push_info": {
                            "aps": {
                                "alert": {
                                    "title": "#{title}",
                                    "body": "#{body}"
                                },
                                "autoBadge": "+1",
                                "content-available": 1
                            }
                     }
            }'
      CURL
      response = %x{#{curl_data}}
      task_id =   JSON.load(response).symbolize_keys[:taskid]

      tokens.each_slice(999).each do |t|
        curl_data = <<-CURL
          curl -H "Content-Type: application/json" \
               -H "authtoken: #{get_getui_auth_token}" \
               https://restapi.getui.com/v1/#{GETUI_APP_ID}/push_list  \
               -XPOST -d '{
                          "cid":#{t},
                          "taskid":"#{task_id}",
                          "need_detail":true
                          }'
        CURL
        system(curl_data)
      end
    rescue
      logger.fatal("ApplicationHelper#send_notification_message=>失败")
    end

    #new,通过单推
    # begin
    #   tokens.each do |item|
    #
    #     curl_data = <<-CURL
    #     curl -H "Content-Type: application/json" \
    #      -H "authtoken:#{get_getui_auth_token}" \
    #      https://restapi.getui.com/v1/#{GETUI_APP_ID}/push_single \
    #      -XPOST -d '{
    #                    "message": {
    #                    "appkey": "#{GETUI_APP_KEY}",
    #                    "is_offline": true,
    #                    "offline_expire_time":10000000,
    #                    "msgtype": "notification"
    #                 },
    #                 "notification": {
    #                     "style": {
    #                         "type": 0,
    #                         "text": "#{body}",
    #                         "title": "#{title}"
    #                     },
    #                     "transmission_type": true,
    #                     "transmission_content": "#{content}"
    #                 },
    #                 "push_info": {
    #                         "aps": {
    #                             "alert": {
    #                                 "title": "#{title}",
    #                                 "body": "#{body}"
    #                             },
    #                             "autoBadge": "+1",
    #                             "content-available": 1
    #                         }
    #                  },
    #                 "cid": "#{item.push_token}",
    #                 "requestid": "#{(Time.now.to_f*1000).to_i}"
    #         }'
    #     CURL
    #     system(curl_data)
    #   end
    # rescue
    #   logger.fatal("ApplicationHelper#send_notification_message=>失败")
    # end

  end

  def broadcast_notification_message title, body, content
    #旧代码
    #RestClient.post("http://182.92.72.30:9000/send_notification_message", {title: title, body: body, content: content, users: "all", action_loc_key: "解锁雅思哥"})

    #new
    begin
      curl_data = <<-CURL
      curl -H "Content-Type: application/json" \
      -H "authtoken:#{get_getui_auth_token}" \
       https://restapi.getui.com/v1/#{GETUI_APP_ID}/push_app \
       -XPOST -d '{
                     "message": {
                     "appkey": "#{GETUI_APP_KEY}",
                     "is_offline": true,
                     "offline_expire_time":10000000,
                     "msgtype": "notification"
                  },
                  "notification": {
                      "style": {
                          "type": 0,
                          "text": "#{body}",
                          "title": "#{title}"
                      },
                      "transmission_type": true,
                      "transmission_content": "#{content}"
                  },
                  "push_info": {
                            "aps": {
                                "alert": {
                                    "title": "#{title}",
                                    "body": "#{body}"
                                },
                                "autoBadge": "+1",
                                "content-available": 1
                            }
                     },
                  "requestid": "#{(Time.now.to_f*1000).to_i}"
              }'
      CURL
      system(curl_data)
    rescue
      logger.fatal("ApplicationHelper#broadcast_notification_message=>失败")
    end
  end

  #直接透传给ios和android
  def send_ios_message title, body, content, users

  end

  def generateNotification title, body, message

  end

  #透传
  def transmissionTemplate message

  end

  def getApnPayload title, body

  end

end

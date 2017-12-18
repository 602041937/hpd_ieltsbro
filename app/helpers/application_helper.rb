require 'rest-client'
require 'digest'
require 'json'

#message 为透传内容
module ApplicationHelper

  GETTUI_PYTHON_SERVER = "http://192.168.2.40:8888"

  def remove_from_collections type, item_id
    AppCollection.where(collection_type: type, item_id: item_id).destroy_all
  end


  def send_slient_message content, users
    tokens=users.map {|x| x.push_token if x.pushable==true}.compact.uniq
    RestClient.post "#{GETTUI_PYTHON_SERVER}/pushMessageToList", {content: content, clientIds: users.to_s}
  end

  def broadcast_slient_message content
    RestClient.post "#{GETTUI_PYTHON_SERVER}/pushMessageToApp", {content: content}
  end

  def send_notification_message title, body, content, users
    android_users=users.map {|x| x if x.pushable==true && x.device=="android"}
    send_slient_message(content, android_users)

    ios_tokens = users.map {|x| x.push_token if x.pushable==true && x.device=="ios"}.compact.uniq
    RestClient.post("#{GETTUI_PYTHON_SERVER}/pushNotificationMessageToList", {title: title, body: body, content: content, clientIds: ios_tokens.to_s})
  end

  def broadcast_notification_message title, body, content

    broadcast_slient_message(content)
    RestClient.post("#{GETTUI_PYTHON_SERVER}/pushNotificationMessageToApp", {title: title, body: body, content: content, phoneTypes: ["IOS"].to_s})
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

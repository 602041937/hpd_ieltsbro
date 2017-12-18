class Common::AppCollectionController < ApplicationController

  #collection_type(video,oral_practice_comment,part1_topic_question, part23_topic_question,oral_memory,written_memory,writing_user_content)

  # 是否收藏了
  # params:collection_type
  # params:item_id,token
  def is_collected
    collection_type = params[:collection_type]
    item_id = params[:item_id]
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "用户无效"} and return if user.blank?
    is_collected = get_is_collected(collection_type, user.id, item_id)
    json = {status: 0, is_collected: is_collected}
    render json: json and return
  end

  # 添加收藏
  # params:item_id,token,collection_type
  def add_to_collection

    collection_type = params[:collection_type]
    item_id = params[:item_id]
    token = params[:token]
    user = verify_token(token)
    render json: {status: 104, message: "用户无效"} and return if user.blank?
    is_collected = get_is_collected(collection_type, user.id, item_id)
    render json: {status: 0, message: "收藏成功"} and return if is_collected
    new_item = AppCollection.new(collection_type: collection_type, item_id: item_id, app_user_id: user.id)
    if new_item.save
      render json: {status: 0, message: "收藏成功"} and return
    end
    render json: {status: 1, message: "收藏失败"} and return
  end

  private
  def get_is_collected(collection_type, app_user_id, item_id)
    count = AppCollection.where(collection_type: collection_type, app_user_id: app_user_id, item_id: item_id).count
    return count>0
  end
end

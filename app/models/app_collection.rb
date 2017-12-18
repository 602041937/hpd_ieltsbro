class AppCollection < ApplicationRecord

  belongs_to :app_user

  $COLLECTION_TYPE_VIDEO = "video"
  $COLLECTION_TYPE_ORAL_PRACTICE_COMMENT = "oral_practice_comment"
  $COLLECTION_TYPE_PART1_TOPIC_QUESTION = "part1_topic_question"
  $COLLECTION_TYPE_PART23_TOPIC_QUESTION = "part23_topic_question"
  $COLLECTION_TYPE_ORAL_MEMORY = "oral_memory"
  $COLLECTION_TYPE_WRITTEN_MEMORY = "written_memory"
  $COLLECTION_TYPE_WRITING_USER_CONTENT = "writing_user_content"

  # 获取item_id,collection_type对应的收藏数
  def self.get_collection_count(item_id, collection_type)
    return self.where(item_id: item_id, collection_type: collection_type).count
  end

  # 获取是否收藏
  def self.get_is_collected(item_id, collection_type)
    return self.where(item_id: item_id, collection_type: collection_type).count>0
  end
end

class AppOralMemory < ApplicationRecord
  belongs_to :app_user
  belongs_to :app_part23_topic
  belongs_to :app_exam_location
  belongs_to :app_exam_date
  has_and_belongs_to_many :app_part1_topics, join_table: :app_oral_memories_app_part1_topics
  has_many :app_oral_memory_comments
end

class AppUser < ApplicationRecord

  mount_uploader :avatar, AvatarUploader
  belongs_to :app_exam_date, optional: true
  belongs_to :app_exam_location, optional: true
  has_many :app_oral_memories, dependent: :destroy
  has_many :app_oral_memory_comments, dependent: :destroy
  has_many :app_written_memories, dependent: :destroy
  has_many :app_written_memory_comments, dependent: :destroy
  has_many :app_oral_practice_comments, dependent: :destroy
  has_many :app_oral_practice_sample_answers, dependent: :destroy
  has_many :app_video_comments, dependent: :destroy
  has_many :app_video_likes, dependent: :destroy
  has_many :app_collections, dependent: :destroy
  has_one :app_destination_country
  has_many :app_oral_practice_stars
  has_many :app_oral_practice_comment_comments
  has_many :app_fan_users

end

class AppVideo < ApplicationRecord
  has_and_belongs_to_many :app_video_categories, join_table: :app_videos_app_video_categories
  has_many :app_video_comments, dependent: :destroy
  has_many :app_video_likes, dependent: :destroy
end

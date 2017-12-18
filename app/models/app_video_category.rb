class AppVideoCategory < ApplicationRecord
  has_and_belongs_to_many :app_videos, join_table: :app_videos_app_video_categories
end

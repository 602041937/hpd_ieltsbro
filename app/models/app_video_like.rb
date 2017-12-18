class AppVideoLike < ApplicationRecord
  belongs_to :app_user
  belongs_to :app_video
end

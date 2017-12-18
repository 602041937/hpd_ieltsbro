class AppVideoComment < ApplicationRecord
  belongs_to :app_video
  belongs_to :app_user

end

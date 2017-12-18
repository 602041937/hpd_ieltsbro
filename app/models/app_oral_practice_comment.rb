class AppOralPracticeComment < ApplicationRecord
  belongs_to :app_user, optional: true
  belongs_to :app_oral_practice_question, optional: true
  mount_uploader :audio_record, AudioRecordUploader
  has_many :app_oral_practice_stars
  has_many :app_oral_practice_comment_comments
end

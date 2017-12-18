class AppOralPracticeQuestion < ApplicationRecord
  belongs_to :app_part1_topic, optional: true
  belongs_to :app_part23_topic, optional: true
  has_many :app_oral_practice_comments
  has_many :app_oral_practice_sample_answers, dependent: :destroy
end

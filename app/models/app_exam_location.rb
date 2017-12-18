class AppExamLocation < ApplicationRecord
  belongs_to :app_exam_city, optional: true
  has_many :app_users
  has_many :app_oral_memories

end

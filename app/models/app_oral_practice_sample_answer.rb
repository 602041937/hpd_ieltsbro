class AppOralPracticeSampleAnswer < ApplicationRecord

  belongs_to :app_user
  belongs_to :app_oral_practice_question, optional: true

end

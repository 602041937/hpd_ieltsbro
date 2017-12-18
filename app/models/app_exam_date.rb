class AppExamDate < ApplicationRecord
  has_many :app_users
  has_many :app_oral_memories
end

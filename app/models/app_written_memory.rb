class AppWrittenMemory < ApplicationRecord
  belongs_to :app_user, optional: true
  has_many :app_written_images
  has_many :app_written_memory_comments
end

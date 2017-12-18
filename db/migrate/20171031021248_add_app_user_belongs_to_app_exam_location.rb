class AddAppUserBelongsToAppExamLocation < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :app_users, :app_exam_location
  end
end

class AddToUserIdToAppOralPracticeStar < ActiveRecord::Migration[5.1]
  def change
    add_column :app_oral_practice_stars, :to_user_id, :integer
  end
end

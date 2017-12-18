class CreateAppVideoCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :app_video_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end

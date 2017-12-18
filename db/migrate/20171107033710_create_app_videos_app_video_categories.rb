class CreateAppVideosAppVideoCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :app_videos_app_video_categories do |t|
      t.integer :app_video_id, index: true
      t.integer :app_video_category_id, index: true
    end
  end
end

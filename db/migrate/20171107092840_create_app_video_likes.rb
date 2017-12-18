class CreateAppVideoLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :app_video_likes do |t|
      t.integer :app_user_id, index: true
      t.integer :app_video_id, index: true
      t.timestamps
    end
  end
end

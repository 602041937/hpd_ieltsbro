class CreateAppVideoComments < ActiveRecord::Migration[5.1]
  def change
    create_table :app_video_comments do |t|
      t.integer :app_user_id, index: true
      t.integer :to_user_id
      t.string :content, default: ""
      t.integer :app_video_id, index: true
      t.integer :to_comment_id
      t.timestamps
    end
  end
end

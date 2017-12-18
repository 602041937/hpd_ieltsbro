class CreateAppOralMemoryComments < ActiveRecord::Migration[5.1]
  def change
    create_table :app_oral_memory_comments do |t|
      t.integer :app_oral_memory_id, index: true
      t.integer :app_user_id, index: true
      t.integer :to_user_id
      t.string :content
      t.integer :to_comment_id
      t.timestamps
    end
  end
end

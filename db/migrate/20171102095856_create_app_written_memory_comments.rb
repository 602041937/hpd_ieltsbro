class CreateAppWrittenMemoryComments < ActiveRecord::Migration[5.1]
  def change
    create_table :app_written_memory_comments do |t|
      t.integer :app_written_memory_id, index: true
      t.integer :app_user_id, index: true
      t.integer :to_comment_id
      t.integer :to_user_id
      t.string :content
      t.integer :the_order
      t.timestamps
    end
  end
end

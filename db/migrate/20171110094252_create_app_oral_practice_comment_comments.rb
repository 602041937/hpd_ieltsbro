class CreateAppOralPracticeCommentComments < ActiveRecord::Migration[5.1]
  def change
    create_table :app_oral_practice_comment_comments do |t|
      t.integer :app_oral_practice_comment_id
      t.integer :app_user_id
      t.integer :to_comment_id
      t.integer :to_user_id
      t.string :content
      t.index :app_oral_practice_comment_id, name: :app_oral_practice_comment_comments_index
      t.index :app_user_id
      t.timestamps
    end
  end
end

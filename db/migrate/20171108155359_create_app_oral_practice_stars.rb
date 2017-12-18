class CreateAppOralPracticeStars < ActiveRecord::Migration[5.1]
  def change
    create_table :app_oral_practice_stars do |t|
      t.integer :fluent, default: 0
      t.integer :vocab, default: 0
      t.integer :grammar, default: 0
      t.integer :pronuce, default: 0
      t.integer :app_user_id
      t.integer :app_oral_practice_comment_id
      t.index :app_user_id
      t.index :app_oral_practice_comment_id
      t.timestamps
    end
  end
end

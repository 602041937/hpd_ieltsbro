class CreateAppOralPracticeComments < ActiveRecord::Migration[5.1]
  def change
    create_table :app_oral_practice_comments do |t|
      t.integer :app_user_id, index: true
      t.integer :seconds
      t.string :audio_record
      t.integer :app_oral_practice_question_id
      t.integer :play_times, default: 0
      t.boolean :is_show, default: true
      t.index :app_oral_practice_question_id, name: :app_oral_practice_comments_index
      t.timestamps
    end
  end
end

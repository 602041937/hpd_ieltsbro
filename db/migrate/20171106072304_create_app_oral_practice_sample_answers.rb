class CreateAppOralPracticeSampleAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :app_oral_practice_sample_answers do |t|
      t.string :content, default: ""
      t.integer :app_user_id, null: false, index: true
      t.boolean :is_show, default: true
      t.boolean :is_default, default: true
      t.integer :app_oral_practice_question_id, null: false
      t.index :app_oral_practice_question_id,name: :app_oral_practice_sample_answers_index
      t.timestamps
    end
  end
end

class CreateAppOralPracticeQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :app_oral_practice_questions do |t|
      t.integer :app_part1_topic_id, index: true
      t.integer :app_part23_topic_id, index: true
      t.string :topic
      t.string :description
      t.boolean :is_show, default: true
      t.integer :comment_count, default: 0
      t.string :vu
      t.string :uu
      t.integer :question_order
      t.integer :part_num
      t.timestamps
    end
  end
end

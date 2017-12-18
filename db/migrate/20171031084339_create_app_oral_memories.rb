class CreateAppOralMemories < ActiveRecord::Migration[5.1]
  def change
    create_table :app_oral_memories do |t|
      t.integer :app_user_id
      t.integer :app_part23_topic_id
      t.integer :app_exam_location_id
      t.integer :app_exam_date_id
      t.string :room_number, default: ""
      t.boolean :is_old, default: false
      t.string :part1, default: ""
      t.string :part2, default: ""
      t.string :part3, default: ""
      t.string :part_all, default: ""
      t.string :impression, default: ""
      t.integer :comment_count, default: 0
      t.boolean :is_show, default: true
      t.integer :collections, default: 0
      t.boolean :part1_is_new_state, default: false
      t.boolean :part23_is_new_state, default: false
      t.boolean :is_meaningless, default: false
      t.timestamps
      t.index :app_user_id
      t.index :app_part23_topic_id
      t.index :app_exam_location_id
      t.index :app_exam_date_id
    end
  end
end

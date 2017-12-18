class CreateAppWrittenMemories < ActiveRecord::Migration[5.1]
  def change
    create_table :app_written_memories do |t|
      t.integer :app_user_id, index: true
      t.string :listening
      t.string :reading
      t.string :writing
      t.string :extras
      t.integer :comment_counts, default: 0
      t.string :location, default: "中国大陆"
      t.string :exam_date, default: ""
      t.integer :collections, default: 0
      t.timestamps
    end
  end
end

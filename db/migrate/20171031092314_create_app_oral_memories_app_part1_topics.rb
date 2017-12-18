class CreateAppOralMemoriesAppPart1Topics < ActiveRecord::Migration[5.1]
  def change
    create_table :app_oral_memories_app_part1_topics do |t|
      t.integer :app_oral_memory_id, index: true
      t.integer :app_part1_topic_id, index: true
    end
  end
end

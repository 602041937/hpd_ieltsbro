class CreateAppPart1Topics < ActiveRecord::Migration[5.1]
  def change
    create_table :app_part1_topics do |t|
      t.string :topic
      t.string :content
      t.boolean :is_show
      t.integer :app_oral_practice_part1_category_id
      t.integer :total_count
      t.integer :oral_practice_collections
      t.string :oral_practice_description
      t.integer :total_comment_count
      t.string :tags
      t.integer :topic_order
      t.boolean :is_show_tab2
      t.boolean :is_sleep
      t.timestamps
      t.index :app_oral_practice_part1_category_id

    end



  end


end

class CreateAppWrittenImages < ActiveRecord::Migration[5.1]
  def change
    create_table :app_written_images do |t|
      t.integer :app_written_memory_id, index: true
      t.string :memory_type
      t.string :image
      t.integer :image_order
      t.timestamps
    end
  end
end

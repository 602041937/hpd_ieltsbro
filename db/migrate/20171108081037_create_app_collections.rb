class CreateAppCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :app_collections do |t|
      t.string :collection_type
      t.integer :item_id
      t.integer :app_user_id, index: true
      t.timestamps
    end
  end
end

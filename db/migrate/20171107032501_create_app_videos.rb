class CreateAppVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :app_videos do |t|
      t.string :name, default: ""
      t.integer :view_count, defalut: 0
      t.string :vu, default: ""
      t.string :uu, default: ""
      t.string :snapshot_url, default: ""
      t.integer :vid
      t.timestamps
    end
  end
end

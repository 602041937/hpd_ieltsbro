class CreateAppFanUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :app_fan_users do |t|
      t.integer :app_user_id
      t.integer :fan_user_id
      t.index :app_user_id
      t.timestamps
    end
  end
end

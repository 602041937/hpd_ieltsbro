class AddSomeColumnsToAppUser < ActiveRecord::Migration[5.1]
  def change
    add_column :app_users, :sex, :string
    add_column :app_users, :device, :string
    add_column :app_users, :current_location, :string
    add_column :app_users, :name_update_count, :integer
    add_column :app_users, :push_token, :string
    add_column :app_users, :device_uid, :string
    add_column :app_users, :device_name, :string
    add_column :app_users, :app_version, :string
    add_column :app_users, :system_version, :string
    add_column :app_users, :app_destination_id, :integer
    add_index :app_users, :app_destination_id
  end
end

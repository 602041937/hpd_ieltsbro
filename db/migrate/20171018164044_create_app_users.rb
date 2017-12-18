class CreateAppUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :app_users do |t|
      t.string :username, null: false, default: ""
      t.string :password, null: false, default: ""
      t.string :mobile, null: false, default: ""
      t.string :zone, null: false, default: ""
      t.string :avatar, default: ""
      t.string :token, default: ""
      t.string :avatar, default: ""
      t.timestamps null: false
    end
  end
end

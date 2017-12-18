class CreateAppUserReports < ActiveRecord::Migration[5.1]
  def change
    create_table :app_user_reports do |t|
      t.string :report_type
      t.integer :item_id
      t.integer :app_user_id, index: true
      t.timestamps
    end
  end
end

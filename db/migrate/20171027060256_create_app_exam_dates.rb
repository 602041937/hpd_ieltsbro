class CreateAppExamDates < ActiveRecord::Migration[5.1]
  def change
    create_table :app_exam_dates do |t|
      t.datetime :date
      t.timestamps
    end
  end
end

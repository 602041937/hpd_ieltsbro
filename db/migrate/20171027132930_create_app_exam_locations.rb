class CreateAppExamLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :app_exam_locations do |t|
      t.string :location
      t.belongs_to :app_exam_city
      t.timestamps
    end
  end
end

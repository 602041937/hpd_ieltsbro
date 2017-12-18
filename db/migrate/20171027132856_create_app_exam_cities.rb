class CreateAppExamCities < ActiveRecord::Migration[5.1]
  def change
    create_table :app_exam_cities do |t|
      t.string :city
      t.timestamps
    end
  end
end

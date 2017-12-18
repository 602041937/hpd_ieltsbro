class CreateAppOralPracticePart23Categories < ActiveRecord::Migration[5.1]
  def change
    create_table :app_oral_practice_part23_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end

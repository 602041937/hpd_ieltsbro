ActiveAdmin.register AppExamLocation do

  menu label: "考试地点", priority: 2

  permit_params :location,:app_exam_city_id

  filter :location, label: "考试地点"
  filter :app_exam_city_id, as: :select, collection: AppExamCity.pluck(:city, :id), label: "所属城市"

  index do
    selectable_column
    id_column
    column :location
    actions
  end

  form do |f|
    f.inputs do
      f.input :location, label: "考试地点"
      f.input :app_exam_city_id, as: :select, collection: AppExamCity.pluck(:city, :id), label: "所属城市"
    end
    f.actions
  end

end

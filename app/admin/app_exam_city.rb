ActiveAdmin.register AppExamCity do

  menu label:"考试城市",priority:3

  permit_params :city

  filter :city

  index do
    selectable_column
    id_column
    column "城市",:city
    actions
  end

end

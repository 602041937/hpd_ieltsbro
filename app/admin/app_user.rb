ActiveAdmin.register AppUser do

  menu label: "用户"

  index do
    selectable_column
    id_column
    column :username
    # column "用户头像" do |item|
    #   image_tag item.avatar.url, size: '50x50'
    # end
    actions
  end

end

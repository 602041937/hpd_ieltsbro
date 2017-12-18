ActiveAdmin.register AppOralMemory do

  #设置menu的标题和显示位置
  menu label: "实时回忆", priority: 1
  #全局设置该model的可操作动作
  actions :all, except: [:new]

  #设置可过滤字段
  filter :part1, label: "part1"
  filter :part2, label: "part2"
  filter :part3, label: "part3"
  filter :impression, label: "考官印象"
  filter :is_show, label: "是否显示"
  filter :is_meaningless, label: "疑似没用"
  filter :app_exam_location_id, label: "考场", as: :select, collection: AppExamLocation.all.map{|x| [x.location,x.id]}

  #设置index页面,row_class指定特殊条件下的row样式
  index(row_class: -> item {'oral_memory_meaningless' if item.is_meaningless}) do
    selectable_column
    id_column
    column "part1", :part1
    column "part2", :part2
    column "part3", :part3
    column "考官印象", :impression
    column "是否显示", :is_show
    column "创建时间" do |item|
      item.created_at.strftime("%Y-%m-%d %H:%M")
    end
    column "疑似广告", :is_meaningless
    column "考场", :app_exam_location_id
    actions
  end

  # #增加action的按钮
  # action_item only: :index do
  #   link_to '刷新疑似状态', admin_app_oral_memories_path, notice: "刷新成功"
  # end

  #增加batch操作按钮
  batch_action "封禁" do |selection|
    AppOralMemory.where(id: selection).update_all(is_show: false)
    redirect_to admin_app_oral_memories_path, notice: "封禁成功"
  end
  batch_action "解封" do |selection|
    AppOralMemory.where(id: selection).update_all(is_show: true)
    redirect_to admin_app_oral_memories_path, notice: "解封成功"
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end

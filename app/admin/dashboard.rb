#获取前7天的数据
def get_days

  current_Ymd = HPDTimeUtils.hpd_dateTimeToYmd(Time.now)
  days_array = []
  7.times {|index|
    days_array << HPDTimeUtils.hpd_dateTimeToYmd(current_Ymd.to_time - (index+1).days).to_s
  }
  return days_array

end

#获取前7天每天的新增用户数
def get_user_register_count_with_days(days)

  user_register_count = []
  days.size.times {|index|
    user_register_count << AppUser.where("created_at > ? and created_at < ?", days[index].to_time, days[index].to_time+1.days).count
  }
  return user_register_count
end


#获取前7天每天的新增录音数
def get_oral_practice_count_with_days(days)

  ral_practice_count = []
  days.size.times {|index|
    ral_practice_count << AppOralPracticeComment.where("created_at > ? and created_at < ?", days[index].to_time, days[index].to_time+1.days).count
  }
  return ral_practice_count
end


#获取前7天每天的新增正常回忆数
def get_oral_memory_count_with_days(days)

  ral_practice_count = []
  days.size.times {|index|
    ral_practice_count << AppOralMemory.where(is_meaningless: :false).where("created_at > ? and created_at < ?", days[index].to_time, days[index].to_time+1.days).count
  }
  return ral_practice_count
end

#获取前7天每天的新增不正常回忆数
def get_meaningless_oral_memory_count_with_days(days)

  ral_practice_count = []
  days.size.times {|index|
    ral_practice_count << AppOralMemory.where(is_meaningless: :true).where("created_at > ? and created_at < ?", days[index].to_time, days[index].to_time+1.days).count
  }
  return ral_practice_count
end


ActiveAdmin.register_page "Dashboard" do

  # menu priority: 1, label: proc {I18n.t("active_admin.dashboard")}
  #
  # days_array = get_days
  # user_register_array = get_user_register_count_with_days(days_array)
  # oral_practice_count_array = get_oral_practice_count_with_days(days_array)
  # content title: proc {I18n.t("active_admin.dashboard")} do
  #   render 'charts', days_array: days_array,
  #          user_register_array: user_register_array,
  #          oral_practice_array: oral_practice_count_array,
  #          oral_memory_array: get_oral_memory_count_with_days(days_array),
  #          meaningless_oral_memory_array: get_meaningless_oral_memory_count_with_days(days_array)
  #
  #   table class: "admin_table" do
  #     tr do
  #       td do
  #         "新增用户数"
  #       end
  #       td do
  #         "新增录音数"
  #       end
  #     end
  #
  #     days_array.size.times do |item|
  #       tr do
  #         td do
  #           "#{days_array[item]} 新增用户数：#{user_register_array[item]}"
  #         end
  #         td do
  #           "#{days_array[item]} 新增录音数：#{oral_practice_count_array[item]}"
  #         end
  #       end
  #     end
  #   end

    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  #end # content
end





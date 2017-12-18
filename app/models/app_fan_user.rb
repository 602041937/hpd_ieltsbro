class AppFanUser < ApplicationRecord

  belongs_to :app_user, optional: true

  # 没有关系
  $APP_FAN_USER_NO_RELATION = 0
  # 我的粉丝
  $APP_FAN_USER_MY_FAN = 1
  # 我的关注
  $APP_FAN_USER_MY_FOLLOW = 2
  # 互粉
  $APP_FAN_USER_BOTH = 3

  # 获取本地用户与目标用户的关系
  def self.get_relationship(my_id, target_user_id)

    count = self.where(app_user_id: my_id, fan_user_id: target_user_id).count
    if count == 0
      count2 = self.where(app_user_id: target_user_id, fan_user_id: my_id).count
      if count2 == 0
        relation = $APP_FAN_USER_NO_RELATION
      else
        relation = $APP_FAN_USER_MY_FAN
      end
    else
      count2 = self.where(app_user_id: target_user_id, fan_user_id: my_id).count
      if count2 == 0
        relation = $APP_FAN_USER_MY_FOLLOW
      else
        relation = $APP_FAN_USER_BOTH
      end
    end

    return relation
  end
end

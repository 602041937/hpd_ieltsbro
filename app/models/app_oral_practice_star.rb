class AppOralPracticeStar < ApplicationRecord
  belongs_to :app_oral_practice_comment
  belongs_to :app_user


  # 判断是否评过星
  def self.get_is_stared(user_id, comment_id)
    count = self.where(app_user_id: user_id, app_oral_practice_comment_id: comment_id).count
    return count>0
  end

end

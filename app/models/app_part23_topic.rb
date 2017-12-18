class AppPart23Topic < ApplicationRecord
  has_many :app_oral_memories
  belongs_to :app_oral_practice_part23_category, optional: true
  has_many :app_oral_practice_questions, dependent: :destroy

  #根据天数（7，30，120)和考点算出数量
  def get_total_count(days, location_id)
    return 0 if days.blank?
    if location_id.blank?
      return self.app_oral_memories.where("created_at>?", DateTime.now-days.to_i).count
    else
      return self.app_oral_memories.where("created_at>? and app_exam_location_id=?", DataTime.now-days.to_i, location_id).count
    end
  end

end

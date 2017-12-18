class AppOralPracticeCommentAddPlayTimesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    offset = (rand*5+5).to_i
    ActiveRecord::Base.connection.execute("update app_oral_practice_comments set play_times = #{offset}+play_times;")
  end

end

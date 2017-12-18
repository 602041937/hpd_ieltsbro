class Common::CountController < ApplicationController

  # 语音的播放次数+1
  # params: id
  def audio
    id = params[:id].to_i
    comment = AppOralPracticeComment.find(id)
    count = comment.play_times ||= 0
    comment.play_times = count + 1
    if comment.save
      render json: {status: 0}
    end
  end

  # 视频的播放次数+1
  # params: id
  def video
    id = params[:id].to_i
    video = AppVideo.find(id)
    count = video.view_count ||= 0
    video.view_count = count+ 1
    if video.save
      render json: {status: 0}
    end
  end
end

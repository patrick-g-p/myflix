class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items.reload.order(list_position: :asc)
  end

  def create
    video = Video.find(params[:video_id])
    list_num = current_user.queue_items.count + 1
    new_queue_item = QueueItem.new(video: video, user: current_user)

    if new_queue_item.save
      flash[:success] = "#{video.title} was added to your queue!"
      redirect_to my_queue_path
    else
      flash[:error] = 'Nothing to see here. Move along.'
      redirect_to video
    end
  end

  private

end

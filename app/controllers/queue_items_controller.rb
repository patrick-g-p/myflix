class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items.reload.order(list_position: :asc)
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video) unless video_in_queue?(video)
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(list_position: new_queue_item_position, video: video, user: current_user)
  end

  def new_queue_item_position
   current_user.queue_items.count + 1
  end

  def video_in_queue?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

end

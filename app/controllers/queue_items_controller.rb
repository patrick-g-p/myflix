class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video) unless current_user.video_in_queue?(video)
    flash[:success] = "#{video.title} was added to your queue!"
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.item_in_queue?(queue_item)
    flash[:danger] = "Title removed from queue"
    current_user.normalize_queue_list
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_list
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid list number"
    end
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(list_position: current_user.new_list_position, video: video, user: current_user)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |item_data|
        item = QueueItem.find(item_data['id'])
        if item.user == current_user
          item.update!(list_position: item_data['list_position'])
          item.rating = item_data['rating']
        end
      end
    end
  end
end

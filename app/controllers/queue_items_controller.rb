class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video) unless video_in_queue?(video)
    flash[:success] = "#{video.title} was added to your queue!"
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item_in_users_queue?(queue_item)
    flash[:danger] = "Title removed from queue"
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      normalize_queue_list
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Something horrible has happened"
    end
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

  def queue_item_in_users_queue?(queue_item)
    current_user.queue_items.include?(queue_item)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |item_data|
        item = QueueItem.find(item_data['id'])
        item.update!(list_position: item_data['list_position']) if item.user == current_user
      end
    end
  end

  def normalize_queue_list
    current_user.queue_items.each_with_index do |item, index_num|
      item.update(list_position: index_num + 1)
    end
  end
end

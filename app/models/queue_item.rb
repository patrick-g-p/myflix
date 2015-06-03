class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video #video_title

  def rating
    review = Review.where(video: video, creator: user).first
    review.rating unless review == nil
  end

  def category_name
    video.category.name
  end
end

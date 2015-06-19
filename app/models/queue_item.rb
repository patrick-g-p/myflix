class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :list_position, {only_integer: true}

  def rating
    review.rating unless review == nil
  end

  def rating=(new_rating)
    if rating
      review.update_column(:rating, new_rating)
    else
      new_review = Review.new(creator: user, video: video, rating: new_rating)
      new_review.save(validate: false)
    end
  end

  def category_name
    video.category.name
  end

  private

  def review
    review ||= Review.where(video: video, creator: user).first
  end
end

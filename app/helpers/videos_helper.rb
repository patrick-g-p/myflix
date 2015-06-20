module VideosHelper
  def proper_rating(average_rating)
    average_rating ? "#{average_rating} / 5.0" : "Has not been rated yet"
  end

  def already_reviewed?(video, user)
    if Review.where(video: video, creator: user).count >= 1
      true
    else
      false
    end
  end

  def review_author(review)
    review.creator == current_user ? 'by you!' : "by #{review.creator.full_name}"
  end
end

module VideosHelper
  def review_author(review)
    review.creator == current_user ? 'you' : "#{review.creator.full_name.titleize}"
  end

  def already_reviewed?(video, user)
    if Review.where(video: video, creator: user).count >= 1
      true
    else
      false
    end
  end
end

module VideosHelper
  def proper_rating(average_rating)
    average_rating ? "#{average_rating} / 5" : "Has not been rated yet" 
  end
end

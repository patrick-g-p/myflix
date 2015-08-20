class VideoDecorator < Draper::Decorator
  delegate_all

  def proper_rating
    object.average_rating ? "#{average_rating} / 5.0" : "Has not been rated yet"
  end
end

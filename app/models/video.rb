class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }

  validates_presence_of :title, :description
  validates_uniqueness_of :title

  def self.search_by_title(search)
    return [] if search.blank?
    self.where("title LIKE ?", "%#{search.titleize}%" ).order('created_at DESC')
  end

  def average_rating
    number_of_ratings = reviews.count
    return nil if number_of_ratings == 0

    sum_of_ratings = 0

    reviews.each do |review|
      sum_of_ratings += review.rating
    end

    sum_of_ratings / number_of_ratings
  end
end

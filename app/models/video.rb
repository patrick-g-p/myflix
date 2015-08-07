class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }

  validates_presence_of :title, :description
  validates_uniqueness_of :title

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search)
    return [] if search.blank?
    where("title ILIKE ?", "%#{search}%" ).order(:title)
  end

  def average_rating
    return nil if reviews.count == 0
    reviews.average(:rating).to_f.round(1)
  end
end

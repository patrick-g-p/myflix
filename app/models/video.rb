class Video < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :title, :description
  validates_uniqueness_of :title

  def self.search_by_title(search)
    return [] if search.blank?
    self.where("title LIKE ?", "%#{search.titleize}%" ).order('created_at DESC')
  end
end

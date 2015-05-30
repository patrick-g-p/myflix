class Video < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :title, :description

  def self.search_by_title(search)
    self.where("title LIKE ?", "%#{search.capitalize}%" )
  end
end

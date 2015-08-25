class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

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

  def as_indexed_json(options={})
    as_json(
      only: [:title, :description],
      include: {reviews: {only: :body}},
      methods: :average_rating
    )
  end

  def self.search(query, options={})
    search_parameters = {
      query: {
        multi_match: {
          query: query,
          fields: ["title^100", "description^50"],
          operator: "AND"
        }
      }
    }

    if options[:reviews].present?
      search_parameters[:query][:multi_match][:fields] << 'reviews.body'
    end

    if options[:rating_from].present? || options[:rating_to].present?
      search_parameters[:filter] = {
        range: {
          average_rating: {
            gte: (options[:rating_from] if options[:rating_from].present?),
            lte: (options[:rating_to] if options[:rating_to].present?)
          }
        }
      }
      search_parameters[:sort] = { average_rating: 'desc' }
    end

    __elasticsearch__.search(search_parameters)
  end
end

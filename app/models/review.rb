class Review < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :video, touch: true

  delegate :title, to: :video, prefix: :video

  validates_presence_of :body, :rating
end

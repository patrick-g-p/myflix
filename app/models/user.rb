class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items, -> { order(:list_position)}

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates :full_name, presence: true, length: {maximum: 30}
end

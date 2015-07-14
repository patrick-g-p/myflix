class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items, -> {order(:list_position)}
  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: 'leader_id'

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates :full_name, presence: true, length: {maximum: 30}

  def owns_queue_item?(queue_item)
    queue_items.include?(queue_item)
  end

  def video_in_queue?(video)
    queue_items.map(&:video).include?(video)
  end

  def new_list_position
   queue_items.count + 1
  end

  def normalize_queue_list
    queue_items.each_with_index do |item, index_num|
      item.update(list_position: index_num + 1)
    end
  end

  def already_following?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
    !(self.already_following?(another_user) || self == another_user)
  end
end

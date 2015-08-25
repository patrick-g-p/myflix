class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items, -> {order(:list_position)}
  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: 'leader_id'
  has_many :invitations, foreign_key: 'inviter_id'
  has_many :payments

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: [:create, :update], length: {minimum: 5}
  validates :full_name, presence: true, length: {maximum: 30}

  def admin?
    self.role == 'admin'
  end

  def locked_account?
    self.account_status == 'locked'
  end

  def lock_account!
    self.update_column(:account_status, 'locked')
    UserMailer.delay.send_failed_payment_notice(self.id)
  end

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

  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end

  def send_password_reset_email
    generate_token!
    UserMailer.delay.password_reset_email(self.id)
  end

  def generate_token!
    self.update_column(:password_reset_token, SecureRandom.urlsafe_base64)
    self.update_column(:password_reset_token_expires_at, Time.zone.now + 2.hours)
  end

  def clear_token!
    self.update_column(:password_reset_token, nil)
    self.update_column(:password_reset_token_expires_at, nil)
  end

  def token_valid?
    password_reset_token_expires_at > Time.zone.now
  end
end

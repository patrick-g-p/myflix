class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'

  validates_presence_of :recipients_email
  validates_presence_of :recipients_name
  validates_presence_of :message

  before_create :set_invitation_token!

  def set_invitation_token!
    self.invitation_token = SecureRandom.urlsafe_base64
  end

  def send_invitation
    UserMailer.send_invitation_email(self).deliver
  end
end

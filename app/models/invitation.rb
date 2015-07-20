class Invitation < ActiveRecord::Base
  include Tokenable
  belongs_to :inviter, class_name: 'User'

  validates_presence_of :recipients_email
  validates_presence_of :recipients_name
  validates_presence_of :message

  def send_invitation
    UserMailer.send_invitation_email(self).deliver
  end
end

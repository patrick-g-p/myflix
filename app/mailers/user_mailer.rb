class UserMailer < ActionMailer::Base
  def registration_welcome_email(user_id)
    @user = User.find(user_id)

    mail from: 'support@myflix.com', to: @user.email, subject: 'Welcome to MyFlix!!'
  end

  def password_reset_email(user_id)
    @user = User.find(user_id)

    mail from: 'support@myflix.com', to: @user.email, subject: 'MyFlix - Reset Your Password'
  end

  def send_invitation_email(invitation_id)
    @invitation = Invitation.find(invitation_id)

    mail from: 'support@myflix.com', to: @invitation.recipients_email, subject: "You're invited to join MyFlix!!"
  end
end

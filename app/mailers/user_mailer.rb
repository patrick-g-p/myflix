class UserMailer < ActionMailer::Base
  def registration_welcome_email(user)
    @user = user

    mail from: 'support@myflix.com', to: user.email, subject: 'Welcome to MyFlix!!'
  end

  def password_reset_email(user)
    @user = user

    mail from: 'support@myflix.com', to: user.email, subject: 'MyFlix - Reset Your Password'
  end
end

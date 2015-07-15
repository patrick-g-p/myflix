class UserMailer < ActionMailer::Base
  def registration_welcome_email(user)
    @user = user

    mail from: ENV['TA_EMAIL'], to: user.email, subject: 'Welcome to MyFlix!!'
  end
end

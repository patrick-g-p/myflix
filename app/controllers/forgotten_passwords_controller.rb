class ForgottenPasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset_email if user
    redirect_to forgot_password_confirm_path
  end

  def confirm
  end
end

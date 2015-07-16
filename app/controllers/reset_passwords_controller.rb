class ResetPasswordsController < ApplicationController
  def show
    @user = User.find_by(password_reset_token: params[:id])

    if @user
      @token = params[:id]
    else
      flash[:warning] = 'Password reset token is invalid. Please try again.'
      redirect_to forgot_password_path
    end
  end

  def create
    @user = User.find_by(password_reset_token: params[:password_reset_token])

    if @user && @user.update(password: params[:password])
      @user.clear_token!
      flash[:success] = 'New password set! Login to MyFlix!'
      redirect_to login_path
    else
      flash[:danger] = 'There were some errors.'
      render :show
    end
  end
end

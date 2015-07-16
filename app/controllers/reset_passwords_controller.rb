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

    if @user && @user.token_valid?
      if @user.update(password: params[:password])
        @user.clear_token!
        flash[:success] = 'New password set! Login to MyFlix!'
        redirect_to login_path
      else
        @token = @user.password_reset_token
        flash[:danger] = 'There were some errors.'
        render :show
      end
    else
      flash[:warning] = 'Password reset token is invalid. Please try again.'
      redirect_to forgot_password_path
    end
  end
end

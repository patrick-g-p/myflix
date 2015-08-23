class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to home_path
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user.locked_account?
      flash[:warning] = "Sorry, your account is locked. Please fix or update your subscription."
      return redirect_to root_path
    end

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = 'Welcome back to MyFlix!'

      if current_user.admin?
        redirect_to new_admin_video_path
      else
        redirect_to home_path
      end
    else
      flash[:danger] = 'Something was wrong with either your email or password.'
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'You logged out successfully. Come back soon!'
    redirect_to root_path
  end
end

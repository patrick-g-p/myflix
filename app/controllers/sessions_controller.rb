class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to home_path
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      if user.locked_account?
        flash[:warning] = "Sorry, your account is locked. Please fix or update your subscription."
        return redirect_to root_path
      elsif user.admin?
        session[:user_id] = user.id
        flash[:success] = 'Welcome Admin'
        redirect_to new_admin_video_path
      else
        session[:user_id] = user.id
        flash[:success] = 'Welcome back to MyFlix!'
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

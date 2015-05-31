class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to home_path
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = 'Welcome back to MyFliX!'
      redirect_to home_path
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

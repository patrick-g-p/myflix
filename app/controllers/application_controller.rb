class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      no_access
    end
  end

  def no_access
    flash[:danger] = "You need to be logged in to do that."
    redirect_to login_path
  end
end

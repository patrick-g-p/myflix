class AdminController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def require_admin
    unless current_user.admin?
      flash[:warning] = "You don't have access to do that."
      redirect_to root_path
    end
  end
end

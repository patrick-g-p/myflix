class PagesController < ApplicationController
  def welcome
    if logged_in?
      redirect_to home_path
    end
  end
end

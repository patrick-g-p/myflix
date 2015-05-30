class PagesController < ApplicationController
  def welcome
    if logged_in?
      redirect_to videos_path
    end
  end
end

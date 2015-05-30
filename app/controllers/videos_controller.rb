class VideosController < ApplicationController
  before_action :require_user

  def index
    @category = Category.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @search_results = Video.search_by_title(params[:search])
  end

  private

end

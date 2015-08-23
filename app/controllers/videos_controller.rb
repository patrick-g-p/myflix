class VideosController < ApplicationController
  before_action :require_user

  def index
    @category = Category.all
  end

  def show
    @video = VideoDecorator.new(Video.find(params[:id]))
    @reviews = @video.reviews
  end

  def search
    @search_results = Video.search_by_title(params[:search])
  end

  def advanced_search
    if params[:query]
      @search_results = Video.search(params[:query]).records.to_a
    else
      @search_results = nil
    end
  end
end

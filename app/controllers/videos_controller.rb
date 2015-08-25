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
    options = {
      reviews: params[:reviews],
      rating_from: params[:rating_from],
      rating_to: params[:rating_to]
    }

    if params[:query]
      @search_results = Video.search(params[:query], options).records.to_a
    else
      @search_results = nil
    end
  end
end

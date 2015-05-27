class VideosController < ApplicationController

  def index
    @category = Category.all
  end

  def show
    @video = Video.find(params[:id])
  end

  private

end

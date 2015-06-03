class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.new(review_params)
    review.creator = current_user

    if review.save
      flash[:success] = "Your review was added! Thanks for contributing!"
      redirect_to @video
    else
      flash[:danger] = "You cannot submit a blank review"
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end

end

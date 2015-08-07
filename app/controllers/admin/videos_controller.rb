class Admin::VideosController < AdminController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "#{@video.title} was added to MyFlix successfully."
      redirect_to new_admin_video_path
    else
      flash[:danger] = "There were some errors with the new video you were uploading, please check the form below."
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover)
  end
end

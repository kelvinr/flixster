class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have successfully create the video #{@video.title}."
      redirect_to new_admin_video_path
    else
      render :new
    end
  end

private

  def video_params
    params.require(:video).permit(:title, :description, :category_id,
                                  :small_cover, :large_cover, :file_name)
  end
end

class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    @reviews = @video.reviews.reload
    @review = Review.new
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

  def watch
    @video = Video.find(params[:id])
    render layout: false
  end
end

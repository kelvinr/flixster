class QueueItemsController < ApplicationController
  before_action :require_user
  before_action :correct_user, only: :destroy

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue(video)
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position numbers."
    end
    redirect_to my_queue_path
  end

  def destroy
    item = QueueItem.find(params[:id])
    QueueItem.delete(item)
    current_user.shift_queue(item.position)
    redirect_to my_queue_path
  end

private

  def queue(video)
    QueueItem.create(video: video, user: current_user,
                     position: queue_position) unless already_queued?(video)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data["id"])
        queue_item.update_attributes!(position: queue_item_data["position"],
                                      rating: queue_item_data["rating"]) if current_user == queue_item.user
      end
    end
  end

  def queue_position
    current_user.queue_items.count + 1
  end

  def already_queued?(video)
    current_user.queue_items.map(&:video).include?(video)
  end
end

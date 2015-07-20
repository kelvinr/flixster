class AddReviewsAverageToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :review_average, :string
  end
end

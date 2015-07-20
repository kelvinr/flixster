class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user, :video, :rating, :comment
end

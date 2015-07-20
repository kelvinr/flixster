class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.review_average.present? ? "#{object.review_average}/5.0" : "N/A"
  end
end

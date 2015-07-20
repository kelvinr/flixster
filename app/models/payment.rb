class Payment < ActiveRecord::Base
  belongs_to :user

  delegate :full_name, :email, to: :user
end

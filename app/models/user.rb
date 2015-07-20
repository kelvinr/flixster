class User < ActiveRecord::Base
  include Tokenable

  attr_accessor :reset_token

  before_save :downcase_email

  has_many :reviews, -> { order(created_at: :asc) }
  has_many :queue_items, -> { order(:position) }
  has_many :invitations, foreign_key: :inviter_id

  has_many :following_relationships, class_name: :Relationship, foreign_key: :follower_id
  has_many :leading_relationships, class_name: :Relationship, foreign_key: :leader_id

  validates_presence_of :email, :full_name, :password
  validates :email, uniqueness: { case_sensitive: false }
 
  has_secure_password validations: false

  def normalize_queue_positions
    queue_items.each_with_index do |item, idx|
      item.update_attributes(position: idx + 1)
    end
  end

  def shift_queue(pos)
    queue_items.each do |item|
      item.update(position: item.position - 1) if item.position > pos
    end
  end

  def queue_position
    queue_items.count + 1
  end

  def queued_video?(video)
    queue_items.exists?(video: video)
  end

  def follows?(another_user)
    following_relationships.pluck(:leader_id).include?(another_user.id)
  end

  def follow(other_user)
    following_relationships.create(leader: other_user) if can_follow?(other_user)
  end

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end

  def clear_reset
    update_attribute(:reset_digest, nil)
  end

  def create_reset_digest
    generate_token(:reset_)
    update_attribute(:reset_digest, User.digest(reset_token))
  end

  def ship(email)
    UserMailer.delay.send(email, self.id)
  end

  def deactivate!
    update_attribute(:active, false)
  end

private

  def downcase_email
    self.email = email.downcase
  end

  def self.digest(token)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(token, cost: cost)
  end
end

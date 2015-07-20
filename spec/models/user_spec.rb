require 'spec_helper'

describe User do
  let(:kate) { Fabricate(:user) }
  let(:bob) { Fabricate(:user) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }

  it { should have_many(:reviews).order(created_at: :asc) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:invitations).with_foreign_key(:inviter_id) }

 it_behaves_like "tokenable", :reset_ do
   let(:object) { Fabricate(:user) }
 end

  describe "digest" do
    it "creates hash from a given string" do
      token = SecureRandom.urlsafe_base64
      digest = User.digest(token)
      expect(BCrypt::Password.new(digest).is_password?(token)).to be_truthy
    end
  end

  describe '#queued_video?' do
    let(:video) { Fabricate(:video) }

    it "returns true when video is in user's queue" do
      Fabricate(:queue_item, user: kate, video: video)
      expect(kate.queued_video?(video)).to be_truthy
    end

    it "returns false when the video isn't in user's queue" do
      expect(kate.queued_video?(video)).to be_falsey
    end
  end

  describe '#follows?' do
    it "returns true if the user has a following relationship with another user" do
      Fabricate(:relationship, leader: bob, follower: kate)
      expect(kate.follows?(bob)).to be_truthy
    end

    it "returns false if the user does not have a following relationship with another user" do
      expect(kate.follows?(bob)).to be_falsey
    end
  end

  describe '#follow' do
    it "follows another user" do
      kate.follow(bob)
      expect(kate.follows?(bob)).to be_truthy
    end

    it "does not follow one self" do
      kate.follow(kate)
      expect(kate.follows?(kate)).to be_falsey
    end
  end

  describe '#create_reset_digest' do
    before { kate.create_reset_digest }

    it "sets users reset token" do
      expect(kate.reset_token).to be_present
    end

    it "sets users reset digest from token" do
      expect(BCrypt::Password.new(kate.reset_digest).is_password?(kate.reset_token)).to be_truthy
    end
  end

  describe '#clear_reset' do
    it "sets users reset_digest to nil" do
      kate.create_reset_digest
      kate.clear_reset
      expect(kate.reset_digest).to be_nil
    end
  end

  describe '#ship' do
    it "sends calling user the given email" do
      kate.ship('welcome_email')
      expect(ActionMailer::Base.deliveries.last.body).to include(kate.full_name)
      kate.create_reset_digest
      kate.ship('password_reset')
      expect(ActionMailer::Base.deliveries.last.body).to include("Reset Password Link")
    end
  end

  describe "#deactivate!" do
    it "deactivates an active user" do
      alice = Fabricate(:user)
      alice.deactivate!
      expect(alice.active?).to be_falsey
    end
  end
end

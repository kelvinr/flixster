require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search_by_title" do
    it "returns an empty array if there is no match" do
      back_to_the_future = Video.create(title: "Back to the Future", description: "A funny doof")
      futurama = Video.create(title: "Futurama", description: "Space travel!")
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      back_to_the_future = Video.create(title: "Back to the Future", description: "A funny doof")
      futurama = Video.create(title: "Futurama", description: "Space travel!")
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end

    it "returns an array of one video for a partial match" do
      back_to_the_future = Video.create(title: "Back to the Future", description: "A funny doof")
      futurama = Video.create(title: "Futurama", description: "Space travel!")
      expect(Video.search_by_title("urama")).to eq([futurama])
    end

    it "returns an array of all matches ordered by created_at" do
      back_to_the_future = Video.create(title: "Back to the Future", description: "A funny doof", created_at: 1.day.ago)
      futurama = Video.create(title: "Futurama", description: "Space travel!")
      expect(Video.search_by_title("Futur")).to eq([futurama, back_to_the_future])
    end

    it "returns an empty array for a search with an empty string" do
      back_to_the_future = Video.create(title: "Back to the Future", description: "A funny doof", created_at: 1.day.ago)
      futurama = Video.create(title: "Futurama", description: "Space travel!")
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe '#update_average_rating' do
    it "updates videos review_average" do
      video = Fabricate(:video)
      Fabricate(:review, video: video)
      video.update_average_rating
      expect(video.review_average).to be_present
    end
  end
end

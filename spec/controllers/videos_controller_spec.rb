require 'spec_helper'

describe VideosController do
  let(:video) { Fabricate(:video) }
  before { set_current_user }

  describe "GET index" do
    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end

    it "sets the @categories" do
      categories = Fabricate.times(2, :category)
      get :index
      expect(assigns(:categories)).to eq(categories)
    end
  end

  describe "GET show" do
    context "Authenticated user" do
      before { get :show, id: video }

      it "sets @video" do
        expect(assigns(:video)).to eq(video)
      end

      it "sets @review" do
        expect(assigns(:review)).to be_a_new(Review)
      end

      it "sets @current_reviews" do
        expect(assigns(:reviews)).to eq(video.reviews)
      end

      it "reviews are in chronological order" do
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video, created_at: 1.day.ago)
        expect(video.reviews).to eq([review1, review2])
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { get :show, id: video }
    end
  end

  describe "GET search" do
    it "sets @results" do
      videos = Fabricate(:video, title: "Futurama")
      get :search, search_term: "Futur"
      expect(assigns(:results)).to eq([videos])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :search }
    end
  end

  describe "GET watch" do
    it_behaves_like "require sign in" do
      let(:action) { get :watch, id: video }
    end

    it "sets @video" do
      get :watch, id: video
      expect(assigns(:video)).to eq(video)
    end

    it "renders without application layout" do
      get :watch, id: video
      expect(response).not_to render_template :application
    end
  end
end

require 'spec_helper'

describe ReviewsController do
  let(:show) { Fabricate(:video) }
  let(:bob) { Fabricate(:user) }

   describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) { post :create, video_id: show.id, review: Fabricate.attributes_for(:review) }
    end

    context "with valid input" do
      before do
        set_current_user(bob)
        post :create, video_id: show.id, review: Fabricate.attributes_for(:review)
      end

      it "creates video review" do
        expect(Review.count).to eq(1)
      end

      it "creates review only with current user" do
        expect(Review.first.user_id).to eq(session[:user_id])
      end

      it "updates the averate rating" do
        expect(Review.first.video.review_average).to be_present
      end

      it "sets the flash message" do
        expect(flash[:success]).to be_present
      end

      it "it redirects to video page" do
        expect(response).to redirect_to show
      end
    end

    context "with invalid input" do
      before(:each) do
        set_current_user(bob)
        post :create, video_id: show.id, review: Fabricate.attributes_for(:review, comment: nil)
      end

      it "doesn't create the review" do
        expect(Review.count).to eq(0)
      end

      it "sets @video" do
        expect(assigns(:video)).to eq(show)
      end

      it "sets @reviews" do
        expect(assigns(:reviews)).to eq(show.reviews)
      end

      it "renders the video show page" do
        expect(response).to render_template 'videos/show'
      end
    end
  end
end

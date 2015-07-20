require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "require admin" do
      let(:action) { get :new }
    end

    it "sets @video to be a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end

    it "sets the flash error message for regular user" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST create" do
    let(:category) { Fabricate(:category) }

    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "require admin" do
      let(:action) { post :create }
     end

     context "with valid input" do
       before do
         set_current_admin
         post :create, video: Fabricate.attributes_for(:video, category_id: category.id)
       end

       it "redirects to the add new video page" do
         expect(response).to redirect_to new_admin_video_path
       end

       it "creates a video" do
         expect(category.videos.count).to eq(1)
       end

       it "sets the flash success message" do
         expect(flash[:success]).to be_present
       end
     end

     context "with invalid input" do
       before do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video, title: nil, category_id: category.id)
      end

       it "renders the new template" do
         expect(response).to render_template :new
       end

       it "does not create a video" do
         expect(category.videos.count).to eq(0)
       end

       it "sets the @video variable" do
         expect(assigns(:video)).to be_present
       end
     end
  end
end

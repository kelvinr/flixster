require 'spec_helper'

describe SessionsController do
  let(:bob) { Fabricate(:user) }

  describe "GET new" do
    it_behaves_like "already logged in" do
      let(:action) { get :new}
    end

    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    it_behaves_like "already logged in" do
      let(:action) { post :create, email: bob.email, password: bob.password }
    end

    context "with valid credentials" do
      before { post :create, email: bob.email, password: bob.password }

      it "creates session with signed in user" do
        expect(session[:user_id]).to eq(bob.id)
      end

      it "redirects to home page" do
        expect(response).to redirect_to :home
      end

      it "sets flash message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid credentials" do
      before { post :create, email: bob.email, password: bob.password + "jfkdlajf" }

      it "doesn't create user session" do
        expect(session[:user_id]).to be_nil
      end

      it "renders new template" do
        expect(response).to render_template :new
      end

      it "sets flash message" do
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "DELETE destroy" do
    before do
      set_current_user
      delete :destroy
    end

    it "clears the session" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root path" do
      expect(response).to redirect_to :root
    end

    it "sets flash message" do
      expect(flash[:info]).to be_present
    end
  end
end

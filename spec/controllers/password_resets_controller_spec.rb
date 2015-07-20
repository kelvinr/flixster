require 'spec_helper'

describe PasswordResetsController do
  let(:bob) { Fabricate(:user) }

  describe "GET new" do
    it_behaves_like "already logged in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it "sets @user" do
      post :create, email: bob.email
      expect(assigns(:user)).to eq(bob)
    end

    it_behaves_like "already logged in" do
      let(:action) { post :create, email: "random@here.com" }
    end

    context "with valid input" do
      before { post :create, email: bob.email }

      it "creates users reset digest" do
        expect(bob.reload.reset_digest).to be_present
      end

      it "sends user the password reset email" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([bob.email])
      end

      it "renders confirmation page" do
        expect(response).to render_template :confirmation
      end
    end

    context "with invalid input" do
      before { post :create, email: "random@example.com" }

      it "sets flash message" do
        expect(flash[:danger]).to be_present
      end

      it "renders new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do
    it_behaves_like "already logged in" do
      let(:action) { get :edit, id: "random" }
    end

    it "sets @user" do
      get :edit, id: "random", email: bob.email
      expect(assigns(:user)).to eq(bob)
    end

    it "renders form with valid link" do
      bob.create_reset_digest
      get :edit, id: bob.reset_token, email: bob.email
      expect(response).to render_template :edit
    end

    it "redirects to expired token with invalid link" do
      bob.create_reset_digest
      get :edit, id: "random", email: bob.email
      expect(response).to redirect_to :expired_token
    end
  end

  describe "PATCH update" do
    it "sets @user" do
      patch :update, id: "random", email: bob.email
      expect(assigns(:user)).to eq(bob)
    end

    it_behaves_like "already logged in" do
      let(:action) { patch :update, id: "random" }
    end

    context "with valid input" do
      before do
        bob.create_reset_digest
        patch :update, id: bob.reset_token, email: bob.email, user: {password: "newpw"}
      end

      it "redirects to login" do
        expect(response).to redirect_to :login
      end

      it "updates user password" do
        expect(bob.password_digest).not_to eq(bob.reload.password_digest)
      end

      it "clears users reset digest" do
        expect(bob.reload.reset_digest).to be_nil
      end

      it "sets flash message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input or link" do
      before { bob.create_reset_digest }

      it "renders edit" do
        patch :update, id: bob.reset_token, email: bob.email, user: {password: ""}
        expect(response).to render_template :edit
      end

      it "redirects to expired token if invalid" do
        patch :update, id: bob.reset_token, email: bob.email, user: {password: "newpw"}
        patch :update, id: bob.reset_token , email: bob.email, user: {password: "something"}
        expect(response).to redirect_to :expired_token
      end
    end
  end
end

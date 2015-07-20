require 'spec_helper'

describe UsersController do
  let(:kate) { Fabricate.attributes_for(:user, email: "kate@example.com") }
  let(:alice) { Fabricate(:user) }

  describe "GET show" do
    it "sets @user" do
      set_current_user(alice)
      get :show, id: alice
      expect(assigns(:user)).to eq(alice)
    end

    it_behaves_like "require sign in" do
      let(:action) { get :show, id: alice}
    end
  end

  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST create" do
    context "successful user sign up" do
      let(:result) { double(:sign_up_result, successful?: true) }

      before do
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: kate
      end

      it { expect(response).to redirect_to :login }

      it { expect(flash[:success]).to be_present }
    end

    context "failed user sign up" do
      let(:result) { double(:sign_up_result, successful?: false, error_msg: "This is an error message") }

      before do
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), token: "1231241"
      end

      it { expect(flash[:danger]).to eq("This is an error message") }

      it { expect(response).to render_template :new }
    end
  end

  describe "GET invited_registration" do
    let(:invitation) { Fabricate(:invitation) }

    it "sets @invitation" do
      get :invited_registration, token: invitation.token
      expect(assigns(:invitation)).to be_a(Invitation)
    end

    it "redirects to expired token page for invalid tokens" do
      get :invited_registration, token: "akldjflakjdfk_9 0"
      expect(response).to redirect_to expired_token_path
    end

    context "with valid token" do
      before { get :invited_registration, token: invitation.token }

      it "renders the :new view template" do
        expect(response).to render_template :new
      end

      it "sets @user with recipient email" do
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end
    end
  end
end

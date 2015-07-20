require 'spec_helper'

describe InvitationsController do

  describe "GET new" do
    it "sets @invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end

    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end

    context "with valid input" do
      before do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith",
                                    recipient_email: "joe@example.com",
                                    message: "Hey join Myflix!" }
      end

      after(:all) { ActionMailer::Base.deliveries.clear }

      it "creates an invitation" do
        expect(Invitation.count).to eq(1)
      end

      it "redirects to the new invitation page" do
        expect(response).to redirect_to :new_invitation
      end

      it "sends an email to the recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      before do
        set_current_user
        post :create, invitation: { recipient_email: "bob@example.com",
                                    message: "Hey join Myflix!" }
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets @invitation" do
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end

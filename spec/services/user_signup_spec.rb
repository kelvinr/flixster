require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    after(:each) { ActionMailer::Base.deliveries.clear }

    context "valid personal info and valid card" do
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdefg") }

      before { StripeWrapper::Customer.should_receive(:create).and_return(customer) }

      it "creates user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token")
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token")
        expect(User.first.customer_token).to eq("abcdefg")
      end

      context "with invited user" do
        let(:alice) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter: alice) }

        before  { UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", invitation.token) }

        it "makes new user follow the inviter" do
          expect(User.last.follows?(alice)).to be_truthy
        end

        it "makes inviter follow the new user" do
          expect(alice.follows?(User.last)).to be_truthy
        end

        it "expires the invitation upon acceptance" do
          expect(Invitation.first.token).to be_nil
        end
      end

      context "sends welcome email" do
        before { UserSignup.new(Fabricate.build(:user, email: "kate@example.com", full_name: "kate long")).sign_up("stripe_token") }

        it "sends out email to the user with valid input" do
          expect(ActionMailer::Base.deliveries.last.to).to eq(["kate@example.com"])
        end

        it "sends out email containing the users name" do
          expect(ActionMailer::Base.deliveries.last.body).to include("kate long")
        end
      end
    end
    
    context "with invalid personal info" do
      before do
        StripeWrapper::Customer.should_not_receive(:create)
        UserSignup.new(Fabricate.build(:user, email: nil)).sign_up("stripe_token")
      end

      it "doesn't create user" do
        expect(User.count).to eq(0)
      end

      it "does not send out welcome email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "valid personal info and declined card"do
      it "does not create a new user record" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token")
        expect(User.count).to eq(0)
      end
    end
  end
end

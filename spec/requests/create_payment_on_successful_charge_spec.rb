require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_16BzODBJ06TFLyLgQ0n4Povh",
      "created" => 1433904989,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_16BzODBJ06TFLyLgS4LgIqB5",
          "object" => "charge",
          "created" => 1433904989,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16BzOCBJ06TFLyLgJqxNn9T8",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 6,
            "exp_year" => 2015,
            "fingerprint" => "3zadDNu4t8ZEhLHh",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6OmyfHTfidE7lu"
          },
          "captured" => true,
          "balance_transaction" => "txn_16BzODBJ06TFLyLgkEeMzCEh",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_6OmyfHTfidE7lu",
          "invoice" => "in_16BzOCBJ06TFLyLgDfOfxeRa",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => "myflix monthly charge",
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "destination" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_16BzODBJ06TFLyLgS4LgIqB5/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_6OmyBKyTngx7Bn",
      "api_version" => "2015-04-07"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_6OmyfHTfidE7lu")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates a payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_6OmyfHTfidE7lu")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_6OmyfHTfidE7lu")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_16BzODBJ06TFLyLgS4LgIqB5")
  end
end

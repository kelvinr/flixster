require 'spec_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" =>  "evt_16CMf5BJ06TFLyLgzLWpkSVb",
      "created" =>  1433994447,
      "livemode" =>  false,
      "type" =>  "charge.failed",
      "data" =>  {
        "object" =>  {
          "id" =>  "ch_16CMf5BJ06TFLyLgtVm0YJiV",
          "object" =>  "charge",
          "created" =>  1433994447,
          "livemode" =>  false,
          "paid" =>  false,
          "status" =>  "failed",
          "amount" =>  999,
          "currency" =>  "usd",
          "refunded" =>  false,
          "source" =>  {
            "id" =>  "card_16CMeEBJ06TFLyLg9hwdhbwq",
            "object" =>  "card",
            "last4" =>  "0341",
            "brand" =>  "Visa",
            "funding" =>  "credit",
            "exp_month" =>  6,
            "exp_year" =>  2020,
            "fingerprint" =>  "S00UdnwA1z59CVwr",
            "country" =>  "US",
            "name" =>  nil,
            "address_line1" =>  nil,
            "address_line2" =>  nil,
            "address_city" =>  nil,
            "address_state" =>  nil,
            "address_zip" =>  nil,
            "address_country" =>  nil,
            "cvc_check" =>  "pass",
            "address_line1_check" =>  nil,
            "address_zip_check" =>  nil,
            "dynamic_last4" =>  nil,
            "metadata" =>  {},
            "customer" =>  "cus_6OrMxSoUB4ULpg"
          },
          "captured" =>  false,
          "balance_transaction" =>  nil,
          "failure_message" =>  "Your card was declined.",
          "failure_code" =>  "card_declined",
          "amount_refunded" =>  0,
          "customer" =>  "cus_6OrMxSoUB4ULpg",
          "invoice" =>  nil,
          "description" =>  "payment to fail",
          "dispute" =>  nil,
          "metadata" =>  {},
          "statement_descriptor" =>  nil,
          "fraud_details" =>  {},
          "receipt_email" =>  nil,
          "receipt_number" =>  nil,
          "shipping" =>  nil,
          "destination" =>  nil,
          "application_fee" =>  nil,
          "refunds" =>  {
            "object" =>  "list",
            "total_count" =>  0,
            "has_more" =>  false,
            "url" =>  "/v1/charges/ch_16CMf5BJ06TFLyLgtVm0YJiV/refunds",
            "data" =>  []
          }
        }
      },
      "object" =>  "event",
      "pending_webhooks" =>  1,
      "request" =>  "iar_6PB1TiIZNMXVhU",
      "api_version" =>  "2015-04-07"
    }
  end

  it "deactivates a user with a web hook data with stripe for failed charge", :vcr do
    alice = Fabricate(:user, customer_token: "cus_6OrMxSoUB4ULpg")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end

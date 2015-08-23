require 'spec_helper'

describe 'payment created on successful card charge', {vcr: true} do
  let(:event_data) do
    {
      "id" => "evt_16cnIEKUdRrCs1LrCevUYGpR",
      "created" => 1440293346,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_16cnIEKUdRrCs1LrI9Q45EsF",
          "object" => "charge",
          "created" => 1440293346,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16cnIDKUdRrCs1LrrDvYsKsU",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2015,
            "fingerprint" => "kuqCAfzAp21fifIi",
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
            "tokenization_method" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6qUGSkaiO56683"
          },
          "captured" => true,
          "balance_transaction" => "txn_16cnIEKUdRrCs1LrSYu8y1nX",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_6qUGSkaiO56683",
          "invoice" => "in_16cnIEKUdRrCs1LrAyAam0JY",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => "Myflix Monthly Charge",
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
            "url" => "/v1/charges/ch_16cnIEKUdRrCs1LrI9Q45EsF/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "req_6qUGgUSsJRLt9A",
      "api_version" => "2015-07-28"
    }
  end

  it 'creates a payment' do
    post '/stripe-events', event_data
    expect(Payment.count).to eq(1)
  end
end

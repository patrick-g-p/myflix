require 'spec_helper'

describe 'payment created on successful card charge', {vcr: true} do
  let(:event_data) do
    {
      "id" => "evt_16cphPKUdRrCs1LrLozYaoBL",
      "created" => 1440302595,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_16cphPKUdRrCs1LrUEyolkfX",
          "object" => "charge",
          "created" => 1440302595,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16cpgwKUdRrCs1LrBOngrNEx",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2016,
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
            "customer" => "cus_6qWk5c28L1PVFx"
          },
          "captured" => true,
          "balance_transaction" => "txn_16cphPKUdRrCs1Lrch4NudJW",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_6qWk5c28L1PVFx",
          "invoice" => nil,
          "description" => "myflix monthly charge",
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
            "url" => "/v1/charges/ch_16cphPKUdRrCs1LrUEyolkfX/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "req_6qWkrSrf3XfTvm",
      "api_version" => "2015-07-28"
    }
  end

  it 'creates a payment' do
    post '/stripe-events', event_data
    expect(Payment.count).to eq(1)
  end

  it 'creates a payment with the correct amount' do
    post '/stripe-events', event_data
    expect(Payment.last.amount).to eq(999)
  end

  it 'creates a payment with the a reference id' do
    post '/stripe-events', event_data
    expect(Payment.last.reference_id).to eq("ch_16cphPKUdRrCs1LrUEyolkfX")
  end

  it 'creates a payment that is associated with a user in the database' do
    danny = Fabricate(:user, customer_token: "cus_6qWk5c28L1PVFx")
    post '/stripe-events', event_data
    expect(Payment.last.user).to eq(danny)
  end
end

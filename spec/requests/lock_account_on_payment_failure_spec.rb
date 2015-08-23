require 'spec_helper'

describe 'lock account on payment spec failure', {vcr: true} do
  after { ActionMailer::Base.deliveries.clear }

  let(:fail_event_data) do
    {
      "id" => "evt_16comgKUdRrCs1LrKlF6k8pb",
      "created" => 1440299078,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_16comgKUdRrCs1Lr9jM7FUvO",
          "object" => "charge",
          "created" => 1440299078,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_16comAKUdRrCs1LrjiubpDHY",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2019,
            "fingerprint" => "Y1aIepUQrAX0qSGo",
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
            "customer" => "cus_6qVm0p7pJaJHJm"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_6qVm0p7pJaJHJm",
          "invoice" => nil,
          "description" => "Myflix Monthly Charge",
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
            "url" => "/v1/charges/ch_16comgKUdRrCs1Lr9jM7FUvO/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "req_6qVoItLhThONJi",
      "api_version" => "2015-07-28"
    }
  end

  it 'it locks out the customer on payment failure' do
    ross = Fabricate(:user, full_name: 'ross', customer_token: "cus_6qVm0p7pJaJHJm")
    post '/stripe-events', fail_event_data
    expect(ross.reload.account_status).to eq('locked')
  end

  it 'send the customer an email informing them of the bad transaction' do
    ross = Fabricate(:user, full_name: 'ross', customer_token: "cus_6qVm0p7pJaJHJm")
    post '/stripe-events', fail_event_data
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it 'sends the email to the correct customer' do
    ross = Fabricate(:user, full_name: 'ross', customer_token: "cus_6qVm0p7pJaJHJm")
    post '/stripe-events', fail_event_data
    expect(ActionMailer::Base.deliveries.last.to).to eq([ross.email])
  end

  it 'has the correct content in the email body' do
    ross = Fabricate(:user, full_name: 'ross', customer_token: "cus_6qVm0p7pJaJHJm")
    post '/stripe-events', fail_event_data
    expect(ActionMailer::Base.deliveries.last.body).to include('Something unfortunatley went with your subscription payment.')
  end
end

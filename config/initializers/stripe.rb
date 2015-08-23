Stripe.api_key = ENV.fetch('STRIPE_TEST_SK')

StripeEvent.configure do
  subscribe 'charge.succeeded' do |event|
    Payment.create
  end
end

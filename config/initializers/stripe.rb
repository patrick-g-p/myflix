Stripe.api_key = ENV.fetch('STRIPE_TEST_SK')

StripeEvent.configure do
  subscribe 'charge.succeeded' do |event|
    user = User.find_by_customer_token(event.data.object.customer)
    Payment.create(amount: event.data.object.amount, reference_id: event.data.object.id, user: user)
  end
end

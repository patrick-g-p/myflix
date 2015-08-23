Stripe.api_key = ENV.fetch('STRIPE_TEST_SK')

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by_customer_token(event.data.object.customer)
    Payment.create(amount: event.data.object.amount, reference_id: event.data.object.id, user: user)
  end

  events.subscribe 'charge.failed' do |event|
    user = User.find_by_customer_token(event.data.object.customer)
    user.lock_account!
  end
end

require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => '4242424242424242',
        :exp_month => 8,
        :exp_year => 2016,
        :cvc => "314"
      },
    ).id
  end

  let(:invalid_token) do
    Stripe::Token.create(
      :card => {
        :number => '4000000000000002',
        :exp_month => 8,
        :exp_year => 2016,
        :cvc => "314"
      },
    ).id
  end

  let(:stripe_test_user) { Fabricate(:user, email: 'stripetest@example.com') }

  describe StripeWrapper::Charge, {vcr: true} do
    describe '.charge' do
      context 'valid card' do
        it 'charges successfully' do
          response = StripeWrapper::Charge.create(amount: 999, token: valid_token, user_email: 'stripetest@example.com')
          expect(response).to be_successful
        end
      end

      context 'invalid card' do
        it 'does not charge the card' do
          response = StripeWrapper::Charge.create(amount: 999, token: invalid_token, user_email: 'stripetest@example.com')
          expect(response).to_not be_successful
        end

        it 'has an error message for the end user' do
          response = StripeWrapper::Charge.create(amount: 999, token: invalid_token, user_email: 'stripetest@example.com')
          expect(response.error_message).to be_present
        end
      end
    end
  end

  describe StripeWrapper::Customer, {vcr: true} do
    describe '.create' do
      context 'valid card' do
        it 'creates a new customer' do
          response = StripeWrapper::Customer.create(token: valid_token, user: stripe_test_user)
          expect(response).to be_successful
        end
      end

      context 'invalid card' do
        it 'does not create a new customer' do
          response = StripeWrapper::Customer.create(token: invalid_token, user: stripe_test_user)
          expect(response).not_to be_successful
        end

        it 'has an error message' do
          response = StripeWrapper::Customer.create(token: invalid_token, user: stripe_test_user)
          expect(response.error_message).to be_present
        end
      end
    end
  end
end

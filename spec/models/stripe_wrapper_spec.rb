require 'spec_helper'

describe StripeWrapper do
  describe '.set_api_key' do
    it 'sets the api key' do
      StripeWrapper.set_api_key
      expect(Stripe.api_key).to be_present
    end
  end

  describe StripeWrapper::Charge do
    before(:each) do
      StripeWrapper.set_api_key
    end

    let(:token) do
      Stripe::Token.create(
        :card => {
          :number => card_number,
          :exp_month => 8,
          :exp_year => 2016,
          :cvc => "314"
        },
      ).id
    end

    context 'valid card' do
      let(:card_number) { '4242424242424242' }

      it 'charges successfully' do
        response = StripeWrapper::Charge.create(amount: 999, token: token, user_email: 'stripetest@example.com')
        expect(response).to be_successful
      end
    end

    context 'invalid card' do
      let(:card_number) { '4000000000000002' }

      it 'does not charge the card' do
        response = StripeWrapper::Charge.create(amount: 999, token: token, user_email: 'stripetest@example.com')
        expect(response).to_not be_successful
      end

      it 'has an error message for the end user' do
        response = StripeWrapper::Charge.create(amount: 999, token: token, user_email: 'stripetest@example.com')
        expect(response.error_message).to be_present
      end
    end
  end
end

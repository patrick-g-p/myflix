require 'spec_helper'

describe ForgottenPasswordsController do
  describe 'POST create' do
    after {ActionMailer::Base.deliveries.clear}

    context 'user in database' do
      let(:a_user) {Fabricate(:user)}

      before(:each) do
        post :create, email: a_user.email
      end

      it 'redirects to the confirmation page' do
        expect(response).to redirect_to forgot_password_confirm_path
      end

      it 'sends the password reset email' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it 'sends the email to the correct user' do
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq([a_user.email])
      end

      it 'sets the users password reset token' do
        expect(a_user.reload.password_reset_token).to_not be_nil
      end
    end

    context 'user not in database' do
      before(:each) do
        post :create, email: 'ilikemovies@gmail.com'
      end

      it 'still redirects to the confirmation page' do
        expect(response).to redirect_to forgot_password_confirm_path
      end

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end

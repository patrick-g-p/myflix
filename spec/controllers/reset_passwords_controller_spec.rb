require 'spec_helper'

describe ResetPasswordsController do
  describe 'GET show' do
    context 'valid token' do
      let(:a_user) {Fabricate(:user)}

      before(:each) do
        a_user.generate_token!
        get :show, id: a_user.password_reset_token
      end

      it 'sets the token instance variable' do
        expect(assigns(:token)).to eq(a_user.password_reset_token)
      end

      it 'renders the show template/new password form' do
        expect(response).to render_template :show
      end
    end

    context 'invalid token' do
      before(:each) do
        get :show, id: 'badt0k3n'
      end

      it 'redirects to the forgot password page' do
        expect(response).to redirect_to forgot_password_path
      end

      it 'lets the user know the token was invalid' do
        expect(flash[:warning]).to eq('Password reset token is invalid. Please try again.')
      end
    end
  end

  describe 'POST create' do
    let(:a_user) {Fabricate(:user)}

    context 'when user is found and the token is valid' do
      context 'with valid password' do
        before(:each) do
          a_user.generate_token!
          post :create, password_reset_token: a_user.password_reset_token, password: 'newpassword'
        end

        it 'redirects to the login page' do
          expect(response).to redirect_to login_path
        end

        it 'assigns the user variable' do
          expect(assigns(:user)).to eq(a_user)
        end

        it 'sets the users new password' do
          expect(a_user.reload.authenticate('newpassword')).to be_truthy
        end

        it 'clears the users password reset token' do
          expect(a_user.reload.password_reset_token).to be_nil
        end
      end

      context 'with invalid password' do
        before(:each) do
          a_user.generate_token!
          post :create, password_reset_token: a_user.password_reset_token, password: 'mf1'
        end

        it 'renders the show template/new password form' do
          expect(response).to render_template :show
        end

        it 'does not update the password' do
          expect(a_user.reload.authenticate('newpassword')).to be_falsey
        end
      end
    end

    context 'when no user is found' do
      it 'redirects to the forgot password page' do
        post :create, password_reset_token: 'badt0k3n', password: 'adifferentpassword'
        expect(response).to redirect_to forgot_password_path
      end
    end

    context 'the token is invalid' do
      it 'redirects to the forgot password page' do
        late_user = Fabricate(:user)
        late_user.generate_token!
        late_user.password_reset_token_expires_at = Time.now - 3.hours
        late_user.save
        post :create, password_reset_token: late_user.password_reset_token, password: 'adifferentpassword'
        expect(response).to redirect_to forgot_password_path
      end
    end
  end
end

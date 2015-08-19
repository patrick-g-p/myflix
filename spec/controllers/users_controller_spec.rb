require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it 'assigns a new instance of User to the @user variable' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST create' do
    let(:charge) { double('charge', successful?: true) }
    let(:bad_charge) { double('charge', successful?: false, error_message: 'Your card was declined') }

    after { ActionMailer::Base.deliveries.clear }

    context 'with valid user and successful card charge' do
      before(:each) do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
        post :create, user: { email: 'geralt@rivia.com', password: 'yennefer', full_name: 'Geralt of Rivia' }, stripeToken: 'tokeny'
      end

      it 'creates a user' do
        expect(User.count).to eq(1)
      end

      it 'redirects to the home path' do
        expect(response).to redirect_to home_path
      end

      it 'sends the email' do
        expect(ActionMailer::Base.deliveries).to be_present
      end

      it 'send the email to the correct user' do
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq([User.first.email])
      end

      it 'has the right content in the email body' do
        email = ActionMailer::Base.deliveries.last
        expect(email.body).to include("You've successfully registered for a MyFlix account")
      end
    end

      context 'with invitation token' do
        let(:inviter) { Fabricate(:user) }
        let(:invited_user) { Fabricate.build(:user) }
        let(:an_invitation) { Fabricate(:invitation, inviter: inviter) }

        before(:each) do
          expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
          post :create, user: {email: an_invitation.recipients_email, password: invited_user.password, full_name: invited_user.full_name}, token: an_invitation.invitation_token, stripeToken: 'tokeny'
        end

        it 'has the new invited user follow the inviter' do
          expect(current_user.reload.already_following?(inviter)).to be_truthy
        end

        it 'has the inviter automatically follow the new user' do
          expect(inviter.reload.already_following?(current_user)).to be_truthy
        end

        it 'removes the invitation token when done' do
          expect(Invitation.first.invitation_token).to be_nil
        end
      end

    context 'with valid user and declined card' do
      before(:each) do
        expect(StripeWrapper::Charge).to receive(:create).and_return(bad_charge)
        post :create, user: { email: 'geralt@rivia.com', password: 'yennefer', full_name: 'Geralt of Rivia' }, stripeToken: 'tokeny'
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'does not create a new user' do
        expect(User.count).to eq(0)
      end

      it 'does not send out an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'sets the flash message with the card error' do
        expect(flash[:danger]).to eq('Your card was declined')
      end
    end

    context 'with invalid user' do
      before(:each) do
        post :create, user: { email: 'geralt@rivia.com', password: 'yennefer' }
      end

      it 'still sets the @user instance variable' do
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'does not create a user' do
        expect(User.count).to be 0
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'does not send out an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'does not attempt to charge the card' do
        expect(StripeWrapper::Charge).not_to receive(:create)
      end
    end
  end

  describe 'GET show' do
    it 'sets the user instance variable' do
      set_current_user
      jensen = Fabricate(:user)
      get :show, id: jensen.id
      expect(assigns(:user)).to eq(jensen)
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) { get :show, id: 42 }
    end
  end

  describe 'GET register_with_token' do
    let(:myflix_user) { Fabricate(:user) }
    let(:an_invitation) { Fabricate(:invitation, inviter: myflix_user) }

    context 'with valid token' do
      before(:each) do
        get :register_with_token, token: an_invitation.invitation_token
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'sets the user instance variable, with the invited persons email' do
        expect(assigns(:user).email).to eq(an_invitation.recipients_email)
      end

      it 'sets the token variable' do
        expect(assigns(:token)).to eq(an_invitation.invitation_token)
      end
    end

    context 'with invalid token' do
      before(:each) do
        get :register_with_token, token: 'n0tarea1t0k3n'
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end

      it 'sets a message that the token is invalid' do
        expect(flash[:warning]).to be_present
      end
    end
  end
end

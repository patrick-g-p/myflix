require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it 'assigns a new instance of User to the @user variable' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST create' do
    after { ActionMailer::Base.deliveries.clear }

    context 'when valid' do
      before(:each) do
        post :create, user: { email: 'geralt@rivia.com', password: 'yennefer', full_name: 'Geralt of Rivia' }
      end

      it 'creates a user' do
        expect(User.count).to eq(1)
      end

      it 'redirects to the home path' do
        expect(response).to redirect_to home_path
      end

      context 'email sending' do
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
    end

    context 'with invitation token' do
      let(:inviter) { Fabricate(:user) }
      let(:invited_user) { Fabricate.build(:user) }
      let(:an_invitation) { Fabricate(:invitation, inviter: inviter) }

      before(:each) do
        post :create, user: {email: an_invitation.recipients_email, password: invited_user.password, full_name: invited_user.full_name}, invitation_token: an_invitation.invitation_token
      end

      it 'has the new invited user follow the inviter' do
        expect(Relationship.first.follower).to eq(current_user)
      end

      it 'has the inviter automatically follow the new user' do
        expect(Relationship.last.follower).to eq(inviter)
      end

      it 'deletes the invitation from the database' do
        expect(Invitation.all.count).to eq(0)
      end
    end

    context 'when invalid' do
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

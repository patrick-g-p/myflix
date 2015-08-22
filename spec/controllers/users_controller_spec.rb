require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it 'assigns a new instance of User to the @user variable' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST create' do
    context 'successful registration' do
      let(:valid_registration) { double(:registration, successful?: true) }

      before(:each) do
        expect_any_instance_of(UserRegistration).to receive(:register_new_user).and_return(valid_registration)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: 'tokeny'
      end

      it { should redirect_to(home_path) }
      it { should set_flash[:success] }
      it { should set_session[:user_id] }
    end

    context 'failed registration' do
      let(:invalid_registration) { double(:registration, successful?: false, error_message: 'an error message') }

      before(:each) do
        expect_any_instance_of(UserRegistration).to receive(:register_new_user).and_return(invalid_registration)
        post :create, user: Fabricate.attributes_for(:user, email: ''), stripeToken: 'tokeny'
      end

      it { should render_template('new') }
      it { should set_flash[:danger].now }
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

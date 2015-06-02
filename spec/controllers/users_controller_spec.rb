require 'spec_helper'

describe UsersController do

  describe 'GET new' do
    it 'assigns a new instance of User to the @user variable' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST create' do

    context 'when valid' do
      before(:each) do
        post :create, user: { email: 'geralt@rivia.com', password: 'yennefer', full_name: 'Geralt of Rivia' }
      end

      it 'creates a user' do
        expect(User.count).to be 1
      end

      it 'redirects to the home path' do
        expect(response).to redirect_to home_path
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
    end
  end

end

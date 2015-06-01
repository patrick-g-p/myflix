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
      it 'creates a user' do
        post :create, user: { email: 'geralt@rivia.com', password: 'yennefer', full_name: 'Geralt of Rivia' }
        expect(User.count).to be 1
      end

      it 'redirects to the home path' do
        post :create, user: { email: 'geralt@rivia.com', password: 'yennefer', full_name: 'Geralt of Rivia' }
        expect(response).to redirect_to :home
      end
    end

    context 'when invalid' do
      it 'does not create a user' do
        post :create, user: { email: 'geralt@rivia.com', password: 'yennefer' }
        expect(User.count).to be 0
      end
    end
  end

end

require 'spec_helper'

describe SessionsController do

  describe 'GET login' do
    it 'redirects to home when logged in' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to :home
    end
  end

  describe 'POST login' do
    it 'redirects to home when a valid session is set' do
      User.create(email: 'geralt@rivia.com', password: 'yennefer', full_name: 'Geralt of Rivia')
      post :create, {email: 'geralt@rivia.com', password: 'yennefer'}
      expect(response).to redirect_to :home
    end
    it 'redirects to login when session hasn\'t been set' do
      post :create
      expect(response).to redirect_to :login
    end
  end

  describe 'GET logout' do
    it 'sets the session user_id to nil' do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(session[:user_id]).to be nil
    end
    it 'redirects to the welcome page/root path' do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(response).to redirect_to :root
    end
  end

end

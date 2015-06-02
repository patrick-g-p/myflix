require 'spec_helper'

describe VideosController do

  let!(:robocop) {Fabricate(:video, title: 'RoboCop')}

  describe 'GET show' do
    it 'sets the @video instance variable if logged in' do
      session[:user_id] = Fabricate(:user).id
      get :show, id: robocop.id
      expect(assigns(:video)).to eq(robocop)
    end

    it 'sets the @reviews instance variable if logged in' do
      session[:user_id] = Fabricate(:user).id
      get :show, id: robocop.id
      robocop.reviews << Fabricate(:review)
      expect(assigns(:reviews)).to eq(robocop.reviews)
    end

    it 'redirects to login page when not authenticated' do
      get :show, id: robocop.id
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'GET search' do
    it 'sets the @search_results instance variable with any videos it finds' do
      session[:user_id] = Fabricate(:user).id
      get :search, search: 'ro'
      expect(assigns(:search_results)).to eq([robocop])
    end

    it 'redirects to login page when not authenticated' do
      get :search, search: 'ro'
      expect(response).to redirect_to(login_path)
    end
  end

end

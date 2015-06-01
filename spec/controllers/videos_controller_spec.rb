require 'spec_helper'

describe VideosController do

  context 'user is logged in' do
    before(:each) do
      session[:user_id] = Fabricate(:user).id
    end

    let!(:robocop) {Fabricate(:video, title: 'RoboCop')}

    describe 'GET show' do
      it 'sets the @video instance variable' do
        get :show, id: robocop.id
        expect(assigns(:video)).to eq(robocop)
      end
      it 'renders the :show template' do
        get :show, id: robocop.id
        expect(response).to render_template :show
      end
    end

    describe 'GET search' do
      it 'sets the @search_results instance variable with any videos it finds' do
        get :search, search: 'ro'
        expect(assigns(:search_results)).to eq([robocop])
      end
      it 'returns an empty array if there are no matching videos' do
        get :search, search: 'the empire strikes back'
        expect(assigns(:search_results)).to eq([])
      end
      it 'renders the search template' do
        get :search, search: "ro"
        expect(response).to render_template :search
      end
    end
  end

  context "user isn't logged in" do
    let!(:star_wars) {Fabricate(:video, title: 'Star Wars: A New Hope')}

    describe 'GET show' do
      it 'redirects to login page when not authenticated' do
        get :show, id: star_wars.id
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'GET search' do
      it 'redirects to login page when not authenticated' do
        get :search, search: 'st'
        expect(response).to redirect_to(login_path)
      end
    end
  end

end

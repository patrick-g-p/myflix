require 'spec_helper'

describe VideosController do
  let(:robocop) { Fabricate(:video, title: 'RoboCop') }

  describe 'GET show' do
    context 'authenticated user' do
      before(:each) { set_current_user }

      it 'sets the @video instance variable if logged in' do
        get :show, id: robocop.id
        expect(assigns(:video)).to eq(robocop)
      end

      it 'sets the @reviews instance variable if logged in' do
        review = Fabricate(:review, video: robocop)
        get :show, id: robocop.id
        expect(assigns(:reviews)).to eq([review])
      end
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) { get :show, id: robocop.id }
    end
  end

  describe 'GET search' do
    context 'authenticated user' do
      before { set_current_user }

      it 'sets the @search_results instance variable with any videos it finds' do
        get :search, search: 'ro'
        expect(assigns(:search_results)).to eq([robocop])
      end
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) { get :search, search: 'ro' }
    end
  end
end

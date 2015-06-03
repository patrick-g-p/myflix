require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it 'sets the @queue_items variable' do
      current_user = Fabricate(:user)
      session[:user_id] = current_user.id
      video = Fabricate(:video)
      queue_items = Fabricate(:queue_item, user: current_user, video: video)
      get :index
      expect(assigns(:queue_items)).to eq([queue_items])
    end
    it 'redirects to the login page when user is not logged in' do
      get :index
      expect(response).to redirect_to login_path
    end
  end
end

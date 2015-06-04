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

  describe 'POST create' do
    it 'redirects to the queue path when successful' do
      current_user = Fabricate(:user)
      session[:user_id] = current_user.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it 'creates a queue item' do
      current_user = Fabricate(:user)
      session[:user_id] = current_user.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it 'creates a queue item associated with the video' do
      current_user = Fabricate(:user)
      session[:user_id] = current_user.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it 'creates a queue item associated with the current_user' do
      current_user = Fabricate(:user)
      session[:user_id] = current_user.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(current_user)
    end

    it 'adds the video at the end of the queue list' do
      current_user = Fabricate(:user)
      session[:user_id] = current_user.id
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: current_user, list_position: 1)
      another_video = Fabricate(:video)
      post :create, video_id: another_video.id
      expect(QueueItem.last.list_position).to be 2
    end

    it 'redirects to login is the user isn\'t logged in' do
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to login_path
    end
  end

end

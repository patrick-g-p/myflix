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
    context 'logged in' do
      let(:current_user) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}

      before(:each) do
        session[:user_id] = current_user.id
      end

      it 'redirects to the queue path when successful' do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it 'creates a queue item' do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it 'creates a queue item associated with the video' do
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it 'creates a queue item associated with the current_user' do
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end

      it 'adds the video at the end of the queue list' do
        Fabricate(:queue_item, video: video, user: current_user, list_position: 1)
        another_video = Fabricate(:video)
        post :create, video_id: another_video.id
        expect(QueueItem.last.list_position).to be 2
      end
    end

    context 'not logged in' do
      it 'redirects to login' do
        video = Fabricate(:video)
        post :create, video_id: 42
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'DELETE destroy' do
    let(:current_user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}
    let(:a_queue_item) {Fabricate(:queue_item, list_position: 1, video: video, user: current_user)}

    it 'redirects back to my queue' do
      session[:user_id] = current_user
      delete :destroy, id: a_queue_item.id
      expect(:response).to redirect_to my_queue_path
    end

    it 'removes the queue item' do
      session[:user_id] = current_user
      delete :destroy, id: a_queue_item.id
      expect(current_user.queue_items).not_to include(a_queue_item)
    end

    it 'does not remove the item if the queue item does not belong to that user' do
      ganondorf = Fabricate(:user)
      session[:user_id] = ganondorf.id
      delete :destroy, id: a_queue_item.id
      expect(current_user.queue_items).to eq([a_queue_item])
    end

    it 'redirects to login, if user is not logged in' do
      delete :destroy, id: 42
      expect(:response).to redirect_to login_path
    end
  end

  describe 'POST update_queue' do
    context 'authenticated user' do
      let(:samus) {Fabricate(:user)}
      before(:each) do
        session[:user_id] = samus.id
      end

      context 'with valid input' do
        it 'redirects to my queue' do
          queue_item1 = Fabricate(:queue_item, user: samus, list_position: 1)
          queue_item2 = Fabricate(:queue_item, user: samus, list_position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 1}, {id: queue_item2.id, list_position: 2}]
          expect(response).to redirect_to my_queue_path
        end
        it 'updates the list position of the queue items' do
          queue_item1 = Fabricate(:queue_item, user: samus, list_position: 1)
          queue_item2 = Fabricate(:queue_item, user: samus, list_position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 2}, {id: queue_item2.id, list_position: 1}]
          expect(samus.queue_items).to eq([queue_item2, queue_item1])
        end
        it 'normalizes the list position numbers' do
          queue_item1 = Fabricate(:queue_item, user: samus, list_position: 1)
          queue_item2 = Fabricate(:queue_item, user: samus, list_position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 1}, {id: queue_item2.id, list_position: 11}]
          expect(samus.queue_items.map(&:list_position)).to eq([1, 2])
        end
      end

      context 'with invalid input' do
        it 'redirects to my queue' do
          queue_item1 = Fabricate(:queue_item, user: samus, list_position: 1)
          queue_item2 = Fabricate(:queue_item, user: samus, list_position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 1.9}, {id: queue_item2.id, list_position: 2}]
          expect(response).to redirect_to my_queue_path
        end
        it 'shows a flash error message' do
          queue_item1 = Fabricate(:queue_item, user: samus, list_position: 1)
          queue_item2 = Fabricate(:queue_item, user: samus, list_position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 1.9}, {id: queue_item2.id, list_position: 2}]
          expect(flash[:error]).to be_present
        end
        it 'does not update the queue items' do
          queue_item1 = Fabricate(:queue_item, user: samus, list_position: 1)
          queue_item2 = Fabricate(:queue_item, user: samus, list_position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 11}, {id: queue_item2.id, list_position: 42.11}]
          expect(queue_item1.reload.list_position).to eq(1)
        end
      end

      it 'does not update queue items if items don\'t belong to current user' do
        ridley = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: samus, list_position: 1)
        queue_item2 = Fabricate(:queue_item, user: ridley, list_position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, list_position: 11}, {id: queue_item2.id, list_position: 42}]
        expect(queue_item2.reload.list_position).to eq(2)
      end
    end

    context 'user is not logged in' do
      it 'redirects to the login path' do
        post :update_queue, queue_items: [{id: 42, list_position: 1}, {id: 11, list_position: 2}]
        expect(response).to redirect_to login_path
      end
    end
  end

end

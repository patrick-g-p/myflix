require 'spec_helper'

describe QueueItemsController do
  let(:adam) { Fabricate(:user, full_name: "Adam Jensen") }

  describe 'GET index' do
    context 'authenticated user' do
      before { set_current_user(adam) }

      it 'sets the @queue_items variable' do
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: adam, video: video)
        get :index
        expect(assigns(:queue_items)).to eq([queue_item])
      end
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    context 'authenticated_user' do
      before(:each) { set_current_user(adam) }

      let(:video) { Fabricate(:video) }

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
        Fabricate(:queue_item, video: video, user: adam, list_position: 1)
        another_video = Fabricate(:video)
        post :create, video_id: another_video.id
        expect(QueueItem.last.list_position).to be 2
      end
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) { post :create, video_id: 1 }
    end
  end

  describe 'DELETE destroy' do
    context 'authenticated_user' do
      before(:each) { set_current_user(adam) }

      let(:video) { Fabricate(:video) }
      let(:a_queue_item) do
        Fabricate(:queue_item, list_position: 1, video: video, user: adam)
      end

      it 'redirects back to my queue' do
        delete :destroy, id: a_queue_item.id
        expect(:response).to redirect_to my_queue_path
      end

      it 'removes the queue item' do
        delete :destroy, id: a_queue_item.id
        expect(adam.queue_items).not_to include(a_queue_item)
      end

      it 'normalizes the queue item list after removing an item' do
        queue_item1 = Fabricate(:queue_item, user: adam, list_position: 1)
        queue_item2 = Fabricate(:queue_item, user: adam, list_position: 2)
        delete :destroy, id: queue_item1.id
        expect(queue_item2.reload.list_position).to eq(1)
      end

      it 'does not remove the item if the queue item does not belong to that user' do
        another_user = Fabricate(:user)
        another_users_queue_item = Fabricate(:queue_item, user: another_user)
        delete :destroy, id: another_users_queue_item.id
        expect(another_user.queue_items).to eq([another_users_queue_item])
      end
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) { post :destroy, id: 1 }
    end
  end

  describe 'POST update_queue' do
    context 'authenticated user' do
      before(:each) { set_current_user(adam) }

      let(:queue_item1) { Fabricate(:queue_item, user: adam, list_position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: adam, list_position: 2) }

      context 'with valid input' do
        it 'redirects to my queue' do
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 1}, {id: queue_item2.id, list_position: 2}]
          expect(response).to redirect_to my_queue_path
        end

        it 'updates the list position of the queue items' do
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 2}, {id: queue_item2.id, list_position: 1}]
          expect(adam.queue_items).to eq([queue_item2, queue_item1])
        end

        it 'normalizes the list position numbers' do
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 1}, {id: queue_item2.id, list_position: 11}]
          expect(adam.queue_items.map(&:list_position)).to eq([1, 2])
        end
      end

      context 'with invalid input' do
        it 'redirects to my queue' do
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 1.9}, {id: queue_item2.id, list_position: 2}]
          expect(response).to redirect_to my_queue_path
        end

        it 'shows a flash error message' do
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 1.9}, {id: queue_item2.id, list_position: 2}]
          expect(flash[:danger]).to be_present
        end

        it 'does not update the queue items' do
          post :update_queue, queue_items: [{id: queue_item1.id, list_position: 11}, {id: queue_item2.id, list_position: 42.11}]
          expect(queue_item1.reload.list_position).to eq(1)
        end
      end

      it 'does not update queue items if items don\'t belong to current user' do
        ridley = Fabricate(:user)
        queue_item2.user = ridley
        post :update_queue, queue_items: [{id: queue_item1.id, list_position: 11}, {id: queue_item2.id, list_position: 42}]
        expect(queue_item2.reload.list_position).to eq(2)
      end
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) do
        post :update_queue, queue_items: [{id: 1, list_position: 1}, {id: 2, list_position: 2}]
      end
    end
  end
end

require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'require_logged_in_user' do
      let(:action) { get :new }
    end

    it 'sets the new instance variable' do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end

    it 'redirects to the root path if user is not an admin' do
      set_current_user
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST create' do
    it_behaves_like 'require_logged_in_user' do
      let(:action) { post :create }
    end

    it_behaves_like 'require_admin' do
      let(:action) { post :create }
    end

    it 'sets the video instance variable' do
      set_current_admin
      new_myflix_video = Fabricate.build(:video, category_id: 5)
      post :create, video: {title: new_myflix_video.title, category_id: new_myflix_video.category_id, description: new_myflix_video.description}
      expect(assigns(:video).title).to eq(new_myflix_video.title)
    end

    context 'valid new video' do
      before(:each) do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video, category_id: 2)
      end

      it 'redirects back to the admin add video page' do
        expect(response).to redirect_to new_admin_video_path
      end
      it 'creates a new video' do
        expect(Video.all.count).to eq(1)
      end
      it 'informs the admin the video was successfully added' do
        expect(flash[:success]).to be_present
      end
    end

    context 'invalid new video' do
      before(:each) do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video, title: '', category_id: 2)
      end

      it 'renders the admin new video form' do
        expect(response).to render_template :new
      end
      it 'does not create a new video' do
        expect(Video.all.count).to eq(0)
      end
      it 'informs the admin of errors' do
        expect(flash[:danger]).to be_present
      end
    end
  end
end

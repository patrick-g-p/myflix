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
end

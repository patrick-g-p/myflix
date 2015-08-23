require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    it 'renders the new template when note logged in' do
      get :new
      expect(response).to render_template :new
    end

    it 'redirects to home when logged in' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    let(:geralt) { Fabricate(:user) }

    context 'when valid' do
      before(:each) do
        post :create, {email: geralt.email, password: geralt.password}
      end

      it 'puts the users id into the session' do
        expect(session[:user_id]).to eq(geralt.id)
      end

      it 'redirects to home' do
        expect(response).to redirect_to home_path
      end
    end

    context 'when account is locked' do
      let(:ciri) { Fabricate(:user, account_status: 'locked') }

      before(:each) { post :create, email: ciri.email, password: ciri.password }

      it { should redirect_to(root_path) }
      it { should set_flash[:warning] }
    end

    context 'valid with admin' do
      let(:triss) { Fabricate(:admin) }

      it 'redirects to the admin dashboard' do
        set_current_admin(triss)
        post :create, {email: triss.email, password: triss.password}
        expect(response).to redirect_to new_admin_video_path
      end
    end

    context 'when invalid' do
      it 'has a value of nil in the session' do
        post :create, {email: geralt.email, password: geralt.password + 'lovesyen'}
        expect(session[:user_id]).to be_nil
      end

      it_behaves_like "require_logged_in_user" do
        let(:action) { post :create, {email: geralt.email, password: '123'} }
      end
    end
  end

  describe 'GET destroy' do
    before(:each) do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it 'sets the session user_id to nil' do
      expect(session[:user_id]).to be_nil
    end
    it 'redirects to the welcome page/root' do
      expect(response).to redirect_to root_path
    end
  end

end

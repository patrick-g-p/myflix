require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do
    it 'sets the relationships instance variable' do
      a_user = Fabricate(:user)
      set_current_user(a_user)
      a_relationship = Fabricate(:relationship, follower: a_user, leader: Fabricate(:user))
      get :index
      expect(assigns(:relationships)).to eq([a_relationship])
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) { get :index }
    end
  end

  describe 'DELETE destroy' do
    context 'logged in user' do
      let(:a_user) { Fabricate(:user) }
      let(:another_user) { Fabricate(:user) }
      let(:a_relationship) do
        Fabricate(:relationship, follower: a_user, leader: another_user)
      end

      it 'redirects to the people page' do
        set_current_user(a_user)
        delete :destroy, id: a_relationship.id
        expect(response).to redirect_to people_path
      end

      it 'removes a relationship' do
        set_current_user(a_user)
        delete :destroy, id: a_relationship.id
        expect(a_user.following_relationships.reload).to eq([])
      end

      it 'does not remove a relationship if it does not belong to the current user' do
        bad_user = Fabricate(:user)
        set_current_user(bad_user)
        delete :destroy, id: a_relationship.id
        expect(a_user.following_relationships.reload).to eq([a_relationship])
      end
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) { delete :destroy, id: 42 }
    end
  end

  describe 'POST create' do
    let(:a_user) { Fabricate(:user) }
    let(:an_intresting_user) { Fabricate(:user) }

    it 'redirects to the people path' do
      set_current_user(a_user)
      post :create, followed_user_id: an_intresting_user.id
      expect(response).to redirect_to people_path
    end

    it 'creates a new relationship associated with the current user' do
      set_current_user(a_user)
      post :create, followed_user_id: an_intresting_user.id
      expect(a_user.following_relationships.reload.count).to eq(1)
    end

    it 'does not create a new relationship if the current user is already following the user' do
      set_current_user(a_user)
      Fabricate(:relationship, follower: a_user, leader: an_intresting_user)
      post :create, followed_user_id: an_intresting_user.id
      expect(Relationship.count).to eq(1)
    end

    it 'does not let the user create a relationship with themselves' do
      set_current_user(a_user)
      post :create, followed_user_id: a_user.id
      expect(Relationship.count).to eq(0)
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) { post :create, followed_user_id: 42 }
    end
  end
end

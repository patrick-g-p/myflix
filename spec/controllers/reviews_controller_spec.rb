require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    let!(:video) {Fabricate(:video)}

    context 'user is logged in' do
      let!(:current_user) {Fabricate(:user)}

      before(:each) do
        session[:user_id] = current_user.id
      end

      context 'the input is valid' do
        before(:each) do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end

        it 'redirects to the videos page' do
          expect(response).to redirect_to video
        end
        it 'sets the @video instance variable' do
          expect(assigns(:video)).to eq(video)
        end
        it 'creates a new review' do
          expect(Review.count).not_to be 0
        end
        it 'creates a review associated with the video' do
          expect(Review.first.video).to eq(video)
        end
        it 'creates a reviews associated with the current user' do
          expect(Review.first.creator).to eq(current_user)
        end
      end

      context 'the input is not valid' do
        it 'renders the videos/show page' do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review, body: '')
          expect(response).to render_template 'videos/show'
        end

        it 'sets the @reviews instance variable' do
          movie_critique = Fabricate(:review)
          video.reviews << movie_critique
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review, body: '')
          expect(assigns(:reviews)).to eq([movie_critique])
        end
      end
    end

    context 'user is not logged in' do
      before(:each) do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
      end

      it 'does not create a new review' do
        expect(video.reviews).to eq([])
      end
      it 'redirects the user to the login page' do
        expect(response).to redirect_to login_path
      end
    end
  end
end

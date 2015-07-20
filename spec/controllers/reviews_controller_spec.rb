require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    let(:video) { Fabricate(:video) }

    context 'user is logged in' do
      before(:each) { set_current_user }

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
          movie_critique = Fabricate(:review, video_id: video.id)
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review, body: '')
          expect(assigns(:reviews)).to eq([movie_critique])
        end
      end
    end

    context 'user is not logged in' do
      it 'does not create a new review' do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        expect(video.reviews).to eq([])
      end

      it_behaves_like "require_logged_in_user" do
        let(:action) do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end
      end
    end
  end
end

require 'spec_helper'

# login
# go to homepage
# click on video
# find a user review, and click to go to profile page
# click on follow
# check to make sure they're in the list
# unfollow
# check to make sure they're no longer in the list

feature 'Users can view each others profiles, and follow one another' do
  let(:arin) {Fabricate(:user)}
  let(:danny) {Fabricate(:user)}
  let(:comic_book_movies) {Fabricate(:category, name: 'Comic Book Movies')}
  let!(:great_video) {Fabricate(:video, title: 'Under The Red Hood', category: comic_book_movies)}
  let!(:great_video_review) {Fabricate(:review, creator: danny, video: great_video)}

  scenario 'A user sees an intresting review, decides to follow the creator, and then later unfollow them' do
    login(arin)
    check_out_a_video(great_video)
    see_intresting_review_and_click_profile_link(danny)
    follows_the_user(danny)
    unfollows_the_user
  end

  def check_out_a_video(video)
    find("a[href='/videos/#{video.id}']").click
  end

  def see_intresting_review_and_click_profile_link(reviewer)
    click_link("#{reviewer.full_name.titleize}")
    expect(page).to have_content("#{reviewer.full_name.titleize}'s Video Collection")
  end

  def follows_the_user(user)
    click_on('Follow')
    expect(page).to have_content('People I Follow')
    expect(page).to have_content("#{user.full_name.titleize}")
  end

  def unfollows_the_user
    find("a[href='/relationships/#{Relationship.first.id}']").click
    expect(page).to have_content('User removed from people you follow.')
  end

end

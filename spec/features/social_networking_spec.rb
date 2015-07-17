require 'spec_helper'

feature 'Users can view each others profiles, and follow one another' do
  let(:arin) { Fabricate(:user) }
  let(:danny) { Fabricate(:user) }
  let(:comic_book_movies) {Fabricate(:category, name: 'Comic Book Movies')}
  let!(:great_video) do
    Fabricate(:video, title: 'Under The Red Hood', category: comic_book_movies)
  end
  let!(:great_video_review) do
    Fabricate(:review, creator: danny, video: great_video)
  end

  scenario 'A user sees an intresting review, decides to follow the creator, and then later unfollow them' do
    login(arin)
    click_video_on_the_homepage(great_video)
    see_intresting_review_and_click_profile_link(danny)
    follow_the_user(danny)
    unfollow_the_user
  end

  def see_intresting_review_and_click_profile_link(reviewer)
    click_link("#{reviewer.full_name.titleize}")
    expect(page).to have_content("#{reviewer.full_name.titleize}'s Video Collection")
  end

  def follow_the_user(user)
    click_on('Follow')
    expect(page).to have_content('People I Follow')
    expect(page).to have_content("#{user.full_name.titleize}")
  end

  def unfollow_the_user
    find("a[href='/relationships/#{Relationship.first.id}']").click
    expect(page).to have_content('User removed from people you follow.')
  end

end

require 'spec_helper'

feature "User logs out" do
  let(:user) {Fabricate(:user)}

  before do
    login(:user)
  end

  scenario "Click the logout button" do
    click_link("Welcome #{user.full_name.titleize}")
    click_link("Sign Out")
    page.should have_content("You logged out successfully. Come back soon!")
  end
end

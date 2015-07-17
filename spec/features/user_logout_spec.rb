require 'spec_helper'

feature "User logs out" do
  let(:adam) { Fabricate(:user) }

  before do
    login(adam)
  end

  scenario "Click the logout button" do
    click_link("Welcome #{adam.full_name.titleize}")
    click_link("Sign Out")
    page.should have_content("You logged out successfully. Come back soon!")
  end
end

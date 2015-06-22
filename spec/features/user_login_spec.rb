require 'spec_helper'

feature 'User logs in' do
  let(:user) {Fabricate(:user)}

  scenario 'with correct input' do
    login(user)
    page.should have_content("Welcome back to MyFliX!")
  end
end

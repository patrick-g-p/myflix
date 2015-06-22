require 'spec_helper'

feature 'User logs in' do
  let(:user) {Fabricate(:user)}

  scenario 'with correct input' do
    login(user)
    page.should have_content("Welcome back to MyFliX!")
  end

  scenario 'with invalid input' do
    visit(login_path)
    fill_in('Email', with: user.email)
    fill_in('Password', with: "wrongpassword")
    click_button("Login")
    page.should have_content("Something was wrong with either your email or password.")
  end
end

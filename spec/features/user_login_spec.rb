require 'spec_helper'

feature 'User logs in' do
  let(:adam) { Fabricate(:user) }

  scenario 'with correct input' do
    login
    page.should have_content("Welcome back to MyFlix!")
  end

  scenario 'with invalid input' do
    visit(login_path)
    fill_in('Email', with: adam.email)
    fill_in('Password', with: "wrongpassword")
    click_button("Login")
    page.should have_content("Something was wrong with either your email or password.")
  end
end

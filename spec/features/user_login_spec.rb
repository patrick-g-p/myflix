require 'spec_helper'

feature 'User logs in' do
  scenario 'with correct input' do
    login
    page.should have_content("Welcome back to MyFlix!")
  end
end

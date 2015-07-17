require 'spec_helper'

feature 'Reset password via email' do
  let!(:gary) { Fabricate(:user) }
  let(:new_password) { 'abrandnewpassword' }

  background do
    clear_emails
  end

  scenario 'An existing user has forgotten their password' do
    go_to_the_forgot_password_page
    enter_email_address(gary)
    check_inbox_and_follow_the_reset_link(gary)
    pick_a_new_password(new_password)
    login_with_new_password(gary, new_password)
  end

  def go_to_the_forgot_password_page
    visit('/')
    click_link('Sign In')
    click_link('Forgot Password?')
    expect(page).to have_content('reset your password')
  end

  def enter_email_address(user)
    fill_in('Email', with: user.email)
    click_on('Reset Password')
  end

  def check_inbox_and_follow_the_reset_link(user)
    open_email(user.email)
    expect(current_email).to have_content('someone (hopefully you!) requested to reset your password')
    current_email.click_link('this link')
    expect(page).to have_content('Choose a new password:')
  end

  def pick_a_new_password(new_password)
    fill_in('Password', with: new_password)
    click_on('Submit Password')
    expect(page).to have_content('New password set!')
  end

  def login_with_new_password(user, password)
    fill_in('Email', with: user.email)
    fill_in('Password', with: password)
    find("input[value='Login']").click
    expect(page).to have_content('Welcome back to MyFlix!')
  end
end

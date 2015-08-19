require 'spec_helper'

feature 'New User Registraion', {js: true, vcr: true} do
  let(:invalid_ivan) { Fabricate.build(:user, email: '') }
  let(:valid_victor) { Fabricate.build(:user) }

  background do
    visit register_path
  end

  scenario 'Valid user and valid card' do
    fill_out_user_info(valid_victor)
    fill_out_card_info("4242424242424242")
    expect(page).to have_content('Your account was set up. Welcome to MyFlix!')
  end

  scenario 'Valid user and declined card' do
    fill_out_user_info(valid_victor)
    fill_out_card_info("4000000000000002")
    expect(page).to have_content('Your card was declined')
  end

  scenario 'Valid user and invalid card' do
    fill_out_user_info(valid_victor)
    fill_out_card_info("42")
    expect(page).to have_content('This card number looks invalid')
  end

  scenario 'Invalid user and valid card' do
    fill_out_user_info(invalid_ivan)
    fill_out_card_info("4242424242424242")
    expect(page).to have_content('Please fix any errors below. Your card was not charged.')
  end

  scenario 'Invalid user and declined card' do
    fill_out_user_info(invalid_ivan)
    fill_out_card_info("4000000000000002")
    expect(page).to have_content('Please fix any errors below. Your card was not charged.')
  end

  scenario 'Invalid user and invalid card' do
    fill_out_user_info(invalid_ivan)
    fill_out_card_info("11")
    expect(page).to have_content('This card number looks invalid')
  end

  def fill_out_user_info(user)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Full Name", with: user.full_name
  end

  def fill_out_card_info(credit_card_number)
    fill_in "Credit Card Number", with: credit_card_number
    fill_in 'CVC', with: '123'
    select "8 - August", from: 'date_month'
    select "2017", from: 'date_year'
    click_on "Register"
  end
end

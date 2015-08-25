require 'spec_helper'

feature 'user payment and billing' do
  let(:brian) { Fabricate(:user, full_name: 'Ninja Brian') }
  let!(:brians_registration_payment) { Fabricate(:payment, user: brian, reference_id: 'notonthepage') }

  scenario 'a user logs in and check their billing page' do
    login(brian)
    click_link 'Welcome Ninja Brian'
    click_link 'Plan and Billing'
    expect(page).to have_content('Myflix Monthly')
    expect(page).to have_content('$9.99')
    expect(page).to have_content(brians_registration_payment.created_at)
    expect(page).not_to have_content(brians_registration_payment.reference_id)
  end
end

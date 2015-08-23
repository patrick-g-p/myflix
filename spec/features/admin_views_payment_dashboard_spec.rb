require 'spec_helper'

feature 'admin panel' do
  let(:myflix_user) { Fabricate(:user, customer_token: '4815162342') }
  let!(:payment) { Fabricate(:payment, user: myflix_user, reference_id: 'nspgg') }

  scenario 'admin views the payment dashboard' do
    login(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content('$9.99')
    expect(page).to have_content("#{myflix_user.full_name}")
    expect(page).to have_content("#{payment.reference_id}")
  end

  scenario 'regular user cannot see the admin payment dashboard' do
    login
    visit admin_payments_path
    expect(page).not_to have_content('$9.99')
    expect(page).not_to have_content("#{myflix_user.full_name}")
    expect(page).not_to have_content("#{payment.reference_id}")

    expect(page).to have_content("You don't have access to do that.")
  end
end

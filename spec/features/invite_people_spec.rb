require 'spec_helper'

feature 'MyFlix users can invite people to use the site' do
  let(:terry) { Fabricate(:user, full_name: 'Terry McGinnis') }
  let(:terrys_invitation) { Fabricate.build(:invitation) }
  let(:future_myflix_user) { Fabricate.build(:user) }

  background do
    clear_emails
  end

  scenario 'A user sends out an invitation, and the recipient accepts' do
    new_invitation_is_sent_out(terry, terrys_invitation)
    recipient_recieves_invitation(terrys_invitation)
    new_user_registers(future_myflix_user)
  end

  def new_invitation_is_sent_out(user, invitation)
    login(user)
    click_on('Invite Friends')
    fill_in("Friend's Email", with: invitation.recipients_email)
    fill_in("Friend's Name", with: invitation.recipients_name)
    fill_in('Message', with: invitation.message)
    click_on('Send Invitation')
    logout(user)
  end

  def recipient_recieves_invitation(invitation)
    open_email(invitation.recipients_email)
    current_email.click_link('Click here to sign up')
  end

  def new_user_registers(user)
    fill_in('Password', with: user.password)
    fill_in('Full Name', with: user.full_name)
    click_on('Register')
    expect(page).to have_content('Your account was set up. Welcome to MyFlix!')
  end
end

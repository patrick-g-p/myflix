require 'spec_helper'

describe UserRegistration do
  let(:a_registration) { UserRegistration.new(Fabricate.build(:user)) }

  describe '#register_new_user' do
    let(:charge) { double('charge', successful?: true) }
    let(:bad_charge) { double('charge', successful?: false, error_message: 'Your card was declined') }

    after { ActionMailer::Base.deliveries.clear }

    context 'with valid user and valid card' do
      before(:each) do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
      end

      it 'creates a user' do
        UserRegistration.new(Fabricate.build(:user)).register_new_user('benderisgreat')
        expect(User.all.count).to eq(1)
      end

      it 'sends out an email confirming the registration' do
        UserRegistration.new(Fabricate.build(:user)).register_new_user('benderisgreat')
        expect(ActionMailer::Base.deliveries).to be_present
      end

      it 'sends the email to the correct user' do
        UserRegistration.new(Fabricate.build(:user)).register_new_user('benderisgreat')
        last_sent_email_address = ActionMailer::Base.deliveries.last.to
        expect(last_sent_email_address).to eq([User.first.email])
      end

      it 'has the correct content in the email' do
        UserRegistration.new(Fabricate.build(:user)).register_new_user('benderisgreat')
        last_sent_email_content = ActionMailer::Base.deliveries.last.body
        expect(last_sent_email_content).to include("You've successfully registered for a MyFlix account")
      end

      context 'with invitation token' do
        let(:invited_user) { Fabricate.build(:user) }
        let(:inviter) { Fabricate(:user) }
        let(:an_invitation) { Fabricate(:invitation, inviter: inviter) }

        it 'has the new user follow the inviter' do
          UserRegistration.new(invited_user).register_new_user('benderisgreat', an_invitation.invitation_token)
          expect(invited_user.reload.already_following?(inviter)).to be_truthy
        end

        it 'has the inviter automatically follow the new user' do
          UserRegistration.new(invited_user).register_new_user('benderisgreat', an_invitation.invitation_token)
          expect(inviter.already_following?(invited_user)).to be_truthy
        end

        it 'clears the invitation token from the database' do
          UserRegistration.new(invited_user).register_new_user('benderisgreat', an_invitation.invitation_token)
          expect(an_invitation.reload.invitation_token).to be_nil
        end
      end

      it 'sets the @status instance variable to successful' do
        registration = UserRegistration.new(Fabricate.build(:user)).register_new_user('benderisgreat')
        expect(registration.instance_variable_get(:@status)).to eq(:successful)
      end
    end

    context 'with valid user and invalid card' do
      before(:each) do
        expect(StripeWrapper::Charge).to receive(:create).and_return(bad_charge)
      end

      it 'does not create a new user' do
        UserRegistration.new(Fabricate.build(:user)).register_new_user('benderisgreat')
        expect(User.all.count).to eq(0)
      end

      it 'does not send out an email' do
        UserRegistration.new(Fabricate.build(:user)).register_new_user('benderisgreat')
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'sets the @status instance variable to failed' do
        registration = UserRegistration.new(Fabricate.build(:user)).register_new_user('benderisgreat')
        expect(registration.instance_variable_get(:@status)).to eq(:failed)
      end
    end

    context 'with invalid user' do
      it 'does not create a user' do
        UserRegistration.new(Fabricate.build(:user, email: '')).register_new_user('benderisgreat')
        expect(User.all.count).to eq(0)
      end

      it 'does not send out an email' do
        UserRegistration.new(Fabricate.build(:user, email: '')).register_new_user('benderisgreat')
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'does not charge the card' do
        UserRegistration.new(Fabricate.build(:user, email: '')).register_new_user('benderisgreat')
        expect(StripeWrapper::Charge).not_to receive(:create)
      end

      it 'sets the @status instance variable to failed' do
        register = UserRegistration.new(Fabricate.build(:user, email: '')).register_new_user('benderisgreat')
        expect(register.instance_variable_get(:@status)).to eq(:failed)
      end
    end
  end
end

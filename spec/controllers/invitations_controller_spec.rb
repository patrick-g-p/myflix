require 'spec_helper'

describe InvitationsController do
  describe 'GET new' do
    it 'sets the invitation instance variable with a new invitation' do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) { get :new }
    end
  end

  describe 'POST create' do
    let(:shulk) { Fabricate(:user) }
    let(:an_invitation) { Fabricate.build(:invitation) }

    after { ActionMailer::Base.deliveries.clear }

    context 'with valid input' do
      before(:each) do
        set_current_user(shulk)
        post :create, invitation: {recipients_name: an_invitation.recipients_name, recipients_email: an_invitation.recipients_email, message: an_invitation.message}
      end

      it 'redirects to the new invitation page' do
        expect(response).to redirect_to invite_path
      end

      it 'creates an invitation' do
        expect(Invitation.all.count).to eq(1)
      end

      it 'sends out the invite email' do
        expect(ActionMailer::Base.deliveries).to be_present
      end

      it 'sends the email to the correct person' do
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq([an_invitation.recipients_email])
      end
    end

    context 'with invalid input' do
      before(:each) do
        set_current_user(shulk)
        post :create, invitation: {recipients_name: '', recipients_email: an_invitation.recipients_email, message: an_invitation.message}
      end

      it 'does not create an invitation' do
        expect(Invitation.all.count).to eq(0)
      end

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'renders the invite page/form' do
        expect(response).to render_template :new
      end
    end

    it_behaves_like 'require_logged_in_user' do
      let(:action) do
        post :create, invitation: {recipients_name: an_invitation.recipients_name, recipients_email: an_invitation.recipients_email, message: an_invitation.message}
      end
    end
  end
end

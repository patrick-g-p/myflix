require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter).class_name('User') }
  it { should validate_presence_of(:recipients_email) }
  it { should validate_presence_of(:recipients_name) }
  it { should validate_presence_of(:message) }

  describe '#set_invitation_token!' do
    it 'should set the new invitations token column' do
      invitation = Fabricate(:invitation)
      expect(invitation.invitation_token).to be_present
    end
  end
end

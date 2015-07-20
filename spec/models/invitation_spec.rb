require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter).class_name('User') }
  it { should validate_presence_of(:recipients_email) }
  it { should validate_presence_of(:recipients_name) }
  it { should validate_presence_of(:message) }

  it_behaves_like 'generates_a_token' do
    let(:object) { Fabricate(:invitation) }
  end
end

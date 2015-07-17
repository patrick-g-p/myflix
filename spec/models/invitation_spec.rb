require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter).class_name('User') }
  it { should validate_presence_of(:recipients_email) }
  it { should validate_presence_of(:recipients_name) }
  it { should validate_presence_of(:message) }
end

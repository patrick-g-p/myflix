require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter).class_name('User') }
end

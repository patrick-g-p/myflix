require 'spec_helper'

describe Review do
  it { should belong_to(:creator)}
  it { should belong_to(:video)}

  it { should delegate_method(:title).to(:video).with_prefix(:video) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:rating) }
end

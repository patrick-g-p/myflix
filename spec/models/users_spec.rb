require 'spec_helper'

decribe User do
  it { should have_secure_password }
  it { should validate_presence_of(:email, :full_name) }
end

require 'spec_helper'

describe User do
  it { should have_secure_password }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items).order(:list_position) }
  it { should have_many(:following_relationships).class_name('Relationship').with_foreign_key('follower_id') }
  it do
    should have_many(:leading_relationships).class_name('Relationship').with_foreign_key('leader_id')
  end

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
end

require 'spec_helper'

describe Category do
  it 'saves to database' do
    category = Category.new(name: 'Space Opera')
    category.save
    expect(category.name).to eq('Space Opera')
  end

  it { should have_many(:videos) }
end

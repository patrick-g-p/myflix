require 'spec_helper'

describe Category do
  it 'saves to database' do
    category = Category.new(name: 'Space Opera')
    category.save
    expect(category.name).to eq('Space Opera')
  end

  it 'has many videos' do
    category = Category.reflect_on_association(:videos)
    expect(category.macro).to eq(:has_many)
  end
end

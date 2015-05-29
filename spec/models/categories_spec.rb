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

  it 'definitley has many videos' do
    category = Category.create(name: 'Space Western')
    firefly = Video.create(title: 'Firefly', description: 'Big damn heroes.', category: category)
    cowboy_beebop = Video.create(title: 'Cowboy Beebop', description: 'Go watch this if you\'ve never seen it', category: category)
    expect(category.videos).to eq([cowboy_beebop, firefly])
  end
end

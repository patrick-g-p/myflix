require 'spec_helper'

describe Video do
  it 'saves to the database' do
    video = Video.new(title: "Firefly",
                      description: "A space western by the magnificent Joss Whedon. There's only one season,  we're just going to break it to you now.",
                      small_cover_url: "firefly.jpg",
                      large_cover_url: "firefly_large.jpg",
                      category_id: 1)
    video.save
    expect(Video.first.title).to eq("Firefly")
  end

  it 'has a category' do
    video = Video.reflect_on_association(:category)
    expect(video.macro).to eq(:belongs_to)
  end

  it 'really has a category' do
    category = Category.create(name: 'Marvel')
    video = Video.create(title: 'Captain America: Winter Solider', description: 'One of the few superhero films that could\'ve stood on its own', category: category)
    expect(video.category).to eq(category)
  end

  it 'has an error with no title' do
    video = Video.create(title: '')
    video.valid?
    expect(video.errors).to have_key(:title)
  end

  it 'has an error with no description' do
    video = Video.create(description: '')
    video.valid?
    expect(video.errors).to have_key(:description)
  end

  it "does not save a video without a title" do
    video = Video.create(description: 'The greatest description EVER')
    expect(Video.count).to eq(0)
  end

  it "does not save a video without a description" do
    video = Video.create(title: 'Video 2: Electric Boogaloo')
    expect(Video.count).to eq(0)
  end
end

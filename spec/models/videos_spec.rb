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
end

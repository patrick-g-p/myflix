require 'spec_helper'

describe Video do
  it { should belong_to(:category) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it 'returns no videos from the database' do
    videos = Video.search_by_title('you get nothing!')
    expect(videos.size).to eq(0)
  end
  it 'returns one video from the database' do
    Video.create(title: 'Samurai Jack', description: 'A samurai is flung into the future.')

    videos = Video.search_by_title('Samurai')
    expect(videos.size).to eq(1)
  end
  it 'returns multiple videos from the databse' do
    Video.create(title: 'Samurai Jack', description: 'A samurai is flung into the future.')
    Video.create(title: 'Samurai Champloo', description: 'Hip-hop soundtrack and the search for the samurai who smells of sunflowers.')

    videos = Video.search_by_title('Samurai')
    expect(videos.size).to be >= 2
  end
end

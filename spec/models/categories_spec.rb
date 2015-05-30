require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe '#recent_videos' do
    before :each do
      @category = Category.create(name: 'Science Fiction')
    end

    it 'returns an empty array if there are no videos in the category' do
      expect(@category.recent_videos).to eq([])
    end

    it 'returns the most recent videos first' do
      the_matrix = Video.create(title: 'The Matrix', description: 'Woah...', category: @category, created_at: 7.day.ago)
      star_wars = Video.create(title: 'Star Wars', description: 'A long time ago in a galaxy far, far away...', category: @category)

      expect(@category.recent_videos).to eq([star_wars, the_matrix])
    end

    it 'returns all videos in the category if there are less than 6' do
      the_matrix = Video.create(title: 'The Matrix', description: 'Woah...', category: @category)
      star_wars = Video.create(title: 'Star Wars', description: 'A long time ago in a galaxy far, far away...', category: @category)
      star_trek = Video.create(title: 'Star Trek', description: 'Not as good as Star Wars ;-)', category: @category)
      farscape = Video.create(title: 'Farscape', description: 'Severly underrated show from the early 2000\'s', category: @category)
      battlestar = Video.create(title: 'Battlestar Galactica 2004', description: 'Damnit Starbuck!', category: @category)

      expect(@category.recent_videos).to eq([battlestar ,farscape ,star_trek, star_wars, the_matrix])
    end

    it 'returns returns the 6 most recent videos if there are more than 6 videos in the category' do
      the_matrix = Video.create(title: 'The Matrix', description: 'Woah...', category: @category)
      star_wars = Video.create(title: 'Star Wars', description: 'A long time ago in a galaxy far, far away...', category: @category)
      star_trek = Video.create(title: 'Star Trek', description: 'Not as good as Star Wars ;-)', category: @category)
      farscape = Video.create(title: 'Farscape', description: 'Severly underrated show from the early 2000\'s', category: @category)
      battlestar = Video.create(title: 'Battlestar Galactica 2004', description: 'Damnit Starbuck!', category: @category)
      stargate = Video.create(title: 'Stargate', description: 'The film that laid the foundation for the long running tv series.', category: @category)
      predator = Video.create(title: 'Predator', description: 'Arnold Schwarzenegger takes on a deadly alien hunter in the middle of the jungle. You\'ll never get bored of this movie.', category: @category)

      expect(@category.recent_videos).not_to include([the_matrix])
    end
  end
end

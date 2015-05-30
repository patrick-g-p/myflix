require 'spec_helper'

describe Video do
  it { should belong_to(:category) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search_by_title" do
    before :each do
      @samurai_jack = Video.create(title: 'Samurai Jack', description: 'A samurai is flung into the future.')
      @samurai_champloo = Video.create(title: 'Samurai Champloo', description: 'Hip-hop soundtrack and the search for the samurai who smells of sunflowers.')
    end

    it 'returns an empty array if no match is found' do
      expect(Video.search_by_title('you get nothing!')).to eq([])
    end

    it 'returns an array of one video if there is a perfect match' do
      expect(Video.search_by_title('Samurai Jack')).to eq([@samurai_jack])
    end

    it 'returns an array of one video if there is a partial match' do
      expect(Video.search_by_title('Jack')).to eq([@samurai_jack])
    end

    it 'returns an array of all matches order by creation date' do
      expect(Video.search_by_title('Samurai')).to eq([@samurai_champloo, @samurai_jack])
    end

    it 'returns an empty array if the search is an empty string' do
      expect(Video.search_by_title('')).to eq([])
    end

  end
end

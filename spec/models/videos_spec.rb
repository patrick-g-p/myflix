require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews)}

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search_by_title" do
    let(:samurai_jack) {Video.create(title: 'Samurai Jack', description: 'A samurai is flung into the future.', created_at: 3.day.ago)}
    let(:samurai_champloo) {Video.create(title: 'Samurai Champloo', description: 'Hip-hop soundtrack and the search for the samurai who smells of sunflowers.')}

    it 'returns an empty array if no match is found' do
      expect(Video.search_by_title('you get nothing!')).to eq([])
    end

    it 'returns an array of one video if there is a perfect match' do
      expect(Video.search_by_title('Samurai Jack')).to eq([samurai_jack])
    end

    it 'returns an array of one video if there is a partial match' do
      expect(Video.search_by_title('Jack')).to eq([samurai_jack])
    end

    it 'returns an array of all matches order by creation date' do
      expect(Video.search_by_title('Samurai')).to eq([samurai_champloo, samurai_jack])
    end

    it 'returns an empty array if the search is an empty string' do
      expect(Video.search_by_title('')).to eq([])
    end

  end

  describe 'total_reviews' do
    it 'returns the exact number of reviews for the video' do
      video = Fabricate(:video)
      video.reviews << Fabricate(:review) << Fabricate(:review)
      expect(video.total_reviews).to eq(2)
    end
  end

  describe 'average_rating' do
    it 'returns nil if there are 0 reviews' do
      video = Fabricate(:video)
      expect(video.average_rating).to be_nil
    end
    it 'returns the average in integer form' do
      video = Fabricate(:video)
      video.reviews << Fabricate(:review) << Fabricate(:review)
      expect(video.average_rating).to be_a(Fixnum)
    end
  end

end

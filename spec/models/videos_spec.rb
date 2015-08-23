require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order('created_at DESC') }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search_by_title" do
    let(:samurai_jack) do
      Video.create(title: 'Samurai Jack', description: 'A samurai is flung into the future.', created_at: 3.day.ago)
    end
    let(:samurai_champloo) do
      Video.create(title: 'Samurai Champloo', description: 'Hip-hop soundtrack and the search for the samurai who smells of sunflowers.')
    end

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

  describe 'average_rating' do
    it 'returns nil if there are 0 reviews' do
      video = Fabricate(:video)
      expect(video.average_rating).to be_nil
    end
    it 'returns the average in integer form' do
      video = Fabricate(:video)
      video.reviews << Fabricate(:review) << Fabricate(:review)
      expect(video.average_rating).to be_a(Float)
    end
  end

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to eq [star_trek, star_wars]
      end
    end
  end
end

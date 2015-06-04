require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  let(:user) {Fabricate(:user)}
  let(:category) {Fabricate(:category)}
  let(:video) {Fabricate(:video, category: category, title:'Mad Max: Fury Road')}
  let(:queue_item) {Fabricate(:queue_item, user: user, video: video)}

  it { should delegate_method(:title).to(:video).with_prefix(:video) }

  describe '#rating' do
    it 'returns the reviews rating' do
      review = Fabricate(:review, video: video, creator: user, rating: 3)
      expect(queue_item.rating).to eq(3)
    end

    it 'returns nil if there is no review' do
      expect(queue_item.rating).to be_nil
    end
  end

  describe '#category_name' do
    it 'returns the name of the category of the associated video' do
      expect(queue_item.category_name).to be(category.name)
    end
  end

  it { should delegate_method(:category).to(:video) }

end

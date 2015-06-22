require 'spec_helper'

feature 'Interacts with the queue' do
  let(:adam) {Fabricate(:user)}
  let!(:anime) {Fabricate(:category, name: "Anime")}
  let!(:trigun) {Fabricate(:video, category: anime)}
  let!(:cowboy_beebop) {Fabricate(:video, category: anime)}

  scenario 'User adds items to the queue and reorders them' do
    login(adam)

    add_video_to_queue(trigun)
    expect_video_to_be_in_queue(trigun)

    visit video_path(trigun)
    expect_link_text_to_be_hidden("Add to Queue")

    add_video_to_queue(cowboy_beebop)

    change_queue_item_list_position(trigun, 2)
    change_queue_item_list_position(cowboy_beebop, 1)
    update_queue

    expect_updated_position(trigun, 2)
    expect_updated_position(cowboy_beebop, 1)
  end

  def add_video_to_queue(video)
    visit videos_path
    find("a[href='/videos/#{video.id}']").click
    click_link("Add to Queue")
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content("#{video.title}")
  end

  def expect_link_text_to_be_hidden(text)
    expect(page).to have_no_content(text)
  end

  def change_queue_item_list_position(video, new_position)
    find("input[data-video-id = '#{video.id}']").set(new_position)
  end

  def update_queue
    click_button("Update Your Queue")
  end

  def expect_updated_position(video, updated_position)
    expect(find("input[data-video-id = '#{video.id}']").value).to eq(updated_position.to_s)
  end
end

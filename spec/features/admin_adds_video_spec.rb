require 'spec_helper'

feature 'add video' do
  let(:jennifer) { Fabricate(:admin) }
  let(:new_release) { Fabricate.build(:video) }
  let!(:new_release_category) { Fabricate(:category) }

  background do
    login(jennifer)
  end

  scenario 'Admin creates a new video release for MyFlix' do
    new_video_page
    fill_out_video_information(new_release, new_release_category)
    add_cover_images
    copy_paste_as3_link
    submit_new_video
  end

  def new_video_page
    visit(new_admin_video_path)
  end

  def fill_out_video_information(video, category)
    fill_in('Title', with: video.title)
    select(category.name, from: 'Category')
    fill_in('Description', with: video.description)
  end

  def add_cover_images
    attach_file('Large Cover', 'app/assets/images/archer_large.jpg')
    attach_file('Small Cover', 'app/assets/images/archer.jpg')
  end

  def copy_paste_as3_link
    fill_in('Amazon S3 Link', with: Faker::Internet.url('s3.amazoaws.com'))
  end

  def submit_new_video
    click_on('Add New Video')
    expect(page).to have_content("#{new_release.title} was added to MyFlix successfully.")
  end
end

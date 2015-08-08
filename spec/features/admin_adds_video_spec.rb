require 'spec_helper'

feature 'add video' do
  let(:jennifer) { Fabricate(:admin) }
  let(:normal_user) { Fabricate(:user) }
  let(:new_release) { Fabricate.build(:video) }
  let!(:new_release_category) { Fabricate(:category) }

  background do
    login(jennifer)
  end

  scenario 'Admin creates a new video release for MyFlix' do
    admin_new_video_page
    fill_out_video_information(new_release, new_release_category)
    add_cover_images
    copy_paste_as3_link
    submit_new_video_and_logout(jennifer)

    login(normal_user)
    views_new_video
  end

  def admin_new_video_page
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
    fill_in('Amazon S3 Link', with: 's3.amazoaws.com/example/video.mp4')
  end

  def submit_new_video_and_logout(admin)
    click_on('Add New Video')
    logout(admin)
  end

  def views_new_video
    visit video_path(Video.last)
    expect(page).to have_selector("a[href='s3.amazoaws.com/example/video.mp4']")
    expect(page).to have_selector("img[src='/uploads/archer_large.jpg']")
  end
end

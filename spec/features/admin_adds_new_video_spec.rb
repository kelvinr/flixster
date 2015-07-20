require 'spec_helper'

feature "Admin adds new Video" do
  scenario "Admin successfully adds a new video" do
    admin = Fabricate(:admin)
    dramas = Fabricate(:category, name: "Dramas")
    sign_in(admin)
    visit new_admin_video_path

    within "#new_video" do
      fill_in "Title", with: "Monk"
      select "Dramas", from: "video_category_id"
      fill_in "Description", with: "A hilarous detective"
      attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
      attach_file "Small cover", "spec/support/uploads/monk.jpg"
      fill_in "File name", with: "monk.mp4"
      click_button "Add Video"
    end

    sign_out
    sign_in

    video = Video.first
    visit video_path(video)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='/videos/#{video.id}/watch']")
  end
end

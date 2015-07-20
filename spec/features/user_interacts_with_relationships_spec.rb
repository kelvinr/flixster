require 'spec_helper'

feature "User interacts with social features" do
  scenario "User follows / unfollows another user" do
    comedy = Fabricate(:category, name: "Comedies")
    video = Fabricate(:video, category: comedy)
    bob = Fabricate(:user)
    kate = Fabricate(:user)
    Fabricate(:review, video: video, user: kate)

    sign_in(bob)
    visit video_path(video)

    click_link(kate.full_name)
    click_link("Follow")

    expect(page).to have_content kate.full_name

    find("td:last-of-type a").click

    expect(page).not_to have_content kate.full_name

    clear_email
  end
end

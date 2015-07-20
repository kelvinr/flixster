require 'spec_helper'

feature "User interacts with user show page" do
  given(:bob) { Fabricate(:user) }
  given(:comedy) { Fabricate(:category, name: "Comedies") }

  background { sign_in(bob) }
  after(:all) { clear_email }

  scenario "User is different user" do
    visit user_path(Fabricate(:user))
    expect(page).to have_content "Follow"
  end

  scenario "User is current user" do
    visit user_path(bob)
    expect(page).not_to have_content "Follow"
  end

  scenario "User has queue items" do
    Fabricate(:queue_item, user: bob, video: Fabricate(:video, title: "Futurama", category: comedy))

    visit user_path(bob)

    expect(find("header h2")).to have_content bob.queue_items.count
    expect(find("tr td:first-child")).to have_content "Futurama"
    expect(find("td:last-of-type")).to have_content "Comedies"
  end

  scenario "User has reviews" do
    review = Fabricate(:review, user: bob, video: Fabricate(:video, title: "Futurama", category: comedy))

    visit user_path(bob)

    expect(find("header h3")).to have_content(bob.reviews.count)
    expect(page).to have_content(review.comment)
  end
end

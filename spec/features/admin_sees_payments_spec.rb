require 'spec_helper'

feature "Admin sees payments" do
  background do
    alice = Fabricate(:user, full_name: "Alice Smith", email: "alice@here.com")
    Fabricate(:payment, user: alice)
  end

  after(:all) { clear_email }

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path

    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice Smith")
    expect(page).to have_content("alice@here.com")
  end

   scenario "user cannot see payments" do
     sign_in(Fabricate(:user))
     visit admin_payments_path

     expect(page).not_to have_content("$9.99")
     expect(page).not_to have_content("Alice Smith")
     expect(page).to have_content("You are not authorized to do that.")
   end
end

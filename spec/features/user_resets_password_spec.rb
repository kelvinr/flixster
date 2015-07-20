require 'spec_helper'

feature "User resets their password" do
  scenario "user succefully resets their pasword" do
    bob = Fabricate(:user, password: "oldpw")
    visit login_path
    click_link "Forgot password?"

    fill_in "Email Address", with: bob.email
    click_button "Send Email"

    open_email(bob.email)
    current_email.click_link("Reset Password Link")

    fill_in "New Password", with: "newpw"
    click_button "Reset Password"

    fill_in "Email Address", with: bob.email
    fill_in "Password", with: "newpw"
    click_button "Sign in"

    expect(page).to have_content "You are now signed in, enjoy!"

    clear_email
  end
end

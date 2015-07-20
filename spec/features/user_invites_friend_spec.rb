require 'spec_helper'

feature "User invites friend" do
  scenario "User successfully invites friend and invitation is accepted", { js: true, vcr: true } do
    alice = Fabricate(:user)
    sign_in(alice)

    invite_friend
    click_link alice.full_name
    click_link "Sign Out"

    friend_accepts_invitation
    friend_signs_in

    inviter_and_friend_should_follow_eachother(alice)

    sign_in(alice)
    inviter_and_friend_should_follow_eachother("Joe Smith")

    clear_email
  end

  def invite_friend
    visit new_invitation_path

    within "#new_invitation" do
      fill_in "Friend's Name", with: "Joe Smith"
      fill_in "Friend's Email Address", with: "joe@example.com"
      fill_in "Message", with: "Myflix is awesome! You should join"
      click_button "Send Invitation"
    end

    expect(page).to have_content "You have successfully invited Joe Smith."
  end

  def friend_accepts_invitation
    open_email "joe@example.com"
    current_email.click_link "Accept this invitation"

    within "#payment-form" do
      fill_in "Password", with: "password"
      fill_in "Full Name", with: "Joe Smith"
      fill_in "Credit Card Number", with: "4242424242424242"
      fill_in "Security Code", with: "434"
      select "7 - July", from: "date_month"
      select "2015", from: "date_year"
      click_button "Sign Up"
    end
  end

  def friend_signs_in
    fill_in "email", with: "joe@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  def inviter_and_friend_should_follow_eachother(other_user)
    click_link "People"
    expect(page).to have_content(other_user.is_a?(String) ? other_user :
                                                            other_user.full_name)
  end
end

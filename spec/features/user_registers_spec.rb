require 'spec_helper'

feature "User registers", {js: true, vcr: true} do
  background { visit register_path }

  scenario "with valid user info and valid card" do
    within "#payment-form" do
      fill_in_valid_user_info
      fill_in_valid_card

      click_button "Sign Up"
    end
    expect(page).to have_content "Thank you for signing up!"
  end

  scenario "with valid user info and invalid card" do
    within "#payment-form" do
      fill_in_valid_user_info
      fill_in_invalid_card

      click_button "Sign Up"
    end
    expect(page).to have_content "This card number looks invalid"
  end

  scenario "with valid user info and invalid card" do
    within "#payment-form" do
      fill_in_valid_user_info
      fill_in_declined_card

      click_button "Sign Up"
    end
    expect(page).to have_content "Your card was declined."
  end

  scenario "with invalid user info and valid card" do
    within "#payment-form" do
      fill_in_invalid_user_info
      fill_in_valid_card

      click_button "Sign Up"
    end
    expect(page).to have_content "Password can't be blank"
  end

  scenario "with invalid user info and invalid card" do
    within "#payment-form" do
      fill_in_invalid_user_info
      fill_in_invalid_card

      click_button "Sign Up"
    end
    expect(page).to have_content "This card number looks invalid"
  end

  scenario "with invalid user info and declined card" do
    within "#payment-form" do
      fill_in_invalid_user_info
      fill_in_declined_card

      click_button "Sign Up"
    end
    expect(page).to have_content "Password can't be blank"
  end

  def fill_in_valid_user_info
    fill_in "Email Address", with: "john@example.com"
    fill_in "Password", with: "123456"
    fill_in "Full Name", with: "John Smith"
  end

  def fill_in_valid_card
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "365"
    select "6 - June", from: "date_month"
    select "2018", from: "date_year"
  end

  def fill_in_invalid_card
    fill_in "Credit Card Number", with: "123"
    fill_in "Security Code", with: "365"
    select "6 - June", from: "date_month"
    select "2018", from: "date_year"
  end

  def fill_in_declined_card
    fill_in "Credit Card Number", with: "4000000000000002"
    fill_in "Security Code", with: "365"
    select "6 - June", from: "date_month"
    select "2018", from: "date_year"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "john@example.com"
    fill_in "Full Name", with: "John Smith"
  end
end

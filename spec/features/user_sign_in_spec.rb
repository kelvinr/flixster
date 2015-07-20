require 'spec_helper'

feature 'User signs in' do
  scenario "with existing username" do
    bob = Fabricate(:user)
    sign_in(bob)
    expect(page).to have_content bob.full_name
  end

  scenario "with deactivated user" do
    bob = Fabricate(:user, active: false)
    sign_in(bob)
    expect(page).not_to have_content bob.full_name
    expect(page).to have_content "Your account has been suspended, please contact customer service."
  end
end

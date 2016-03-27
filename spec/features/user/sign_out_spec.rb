require 'rails_helper'

feature 'User sign out', %q{
  For security purpose
  As an authorised user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authorised user tries to sign out' do
    sign_in(user)
    click_on 'Sign out'


    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end

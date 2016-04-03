require 'rails_helper'

feature 'User sign out', %q(
  For security purpose
  As an authorised user
  I want to be able to sign out
) do
  given(:user) { create(:user) }

  scenario 'Authorised user tries to sign out' do
    sign_in(user)
    click_on I18n.t 'users.sign_out'

    expect(page).to have_content I18n.t 'devise.sessions.signed_out'
    expect(current_path).to eq root_path
  end
end

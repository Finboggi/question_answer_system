require 'rails_helper'

feature 'User sign out', %q(
  In order to be able to sign in
  As a not registered user
  I want to be able to register
) do
  scenario 'Existing user tries to register' do
    register(create(:user))

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq user_registration_path
  end

  scenario 'Non-existing user tries to register' do
    register(User.new(email: 'new_email@test.com', password: '12345678'))

    expect(page).to have_content I18n.t 'devise.registrations.signed_up'
    expect(current_path).to eq root_path
  end
end

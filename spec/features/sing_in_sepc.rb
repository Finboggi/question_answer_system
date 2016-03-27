require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be order to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Not registered users tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end
end

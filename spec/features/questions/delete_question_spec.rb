require 'rails_helper'

feature 'delete question', %q{
  In order to remove my question from system
  As an authenticated user
  I want to be able to delete question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  scenario 'Authenticated user tries to delete question he created' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(current_path).to eq root_path
    save_and_open_page
    expect(page).to have_content 'Your question was deleted'
  end

  scenario 'Authenticated user tries to delete question of another user'
  scenario 'Non-authenticated user tries to delete question'
end
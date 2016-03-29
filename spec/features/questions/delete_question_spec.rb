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
    visit question_path(create(:question, user_id: user.id))
    click_on I18n.t('questions.delete.link')

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('questions.delete.success')
  end

  scenario 'Authenticated user tries to delete question of another user' do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).to_not have_link(I18n.t('questions.delete.link'), href: question_path(question))
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)
    expect(page).to_not have_link(I18n.t('questions.delete.link'), href: question_path(question))
  end
end
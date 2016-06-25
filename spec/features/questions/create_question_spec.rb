require_relative '../feature_helper'

feature 'create question', %q(
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
) do
  scenario 'authenticated user creates question' do
    login_as(create(:user))
    question = build(:question)

    visit questions_path
    click_on I18n.t 'questions.new.link'

    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on I18n.t('questions.new.button')

    expect(page).to have_content I18n.t 'questions.new.success'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Non-authenticated user creates question' do
    visit questions_path
    click_on I18n.t 'questions.new.link'

    expect(page).to have_content I18n.t 'devise.failure.unauthenticated'
  end
end

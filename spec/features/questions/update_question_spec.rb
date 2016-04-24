require_relative '../feature_helper'

feature 'update questions', %q(
  In order to update question
  Authorizes user
  must be able to edit questions title and body
  ) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authorized user trying to update his question', js: true do
    login_as(question.user)
    visit question_path(question)
    click_on I18n.t 'questions.edit.link'
    within '#edit_question' do
      fill_in 'Title', with: 'Alter question title'
      fill_in 'Body', with: 'Alter question body'
      click_on I18n.t 'questions.edit.button'
    end

    expect(page).to have_content I18n.t 'questions.update.success'
    expect(page).to have_content 'Alter question title'
    expect(page).to have_content 'Alter question body'
  end

  # TODO: следующие два теста очень похожи, рефакторинг?
  scenario 'Authorized user trying to update other user\'s question'
  scenario 'Unauthorized user trying to update question'
end
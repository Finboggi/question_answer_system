require_relative '../feature_helper'

feature 'update answers', %q(
  In order to update answer
  Authorized user
  must be able to edit questions title and body
  ) do
  given(:question) { create(:question, :with_answers) }
  given(:answer) { question.answers.first }
  given(:answer_not_owned) { question.answers.second }

  scenario 'Authorized user trying to update his question', js: true do
    login_as(answer.user)
    visit question_path(question)
    within "#answer_#{answer.id}" do
      click_on I18n.t 'answers.edit.link'
    end
    within '#edit_answer' do
      fill_in 'Body', with: 'Alter answer body'
      click_on I18n.t 'answers.edit.button'
    end

    expect(page).to have_content I18n.t 'answers.update.success'
    expect(page).to have_content 'Alter answer body'
  end

  describe 'wrong user' do
    scenario 'Authorized user trying to update other user\'s question' do
      login_as(answer.user)
      visit question_path(question)
      within "#answer_#{answer_not_owned.id}" do
        expect(page).to_not have_content I18n.t 'answers.edit.link'
      end
    end

    scenario 'Unauthorized user trying to update question' do
      visit question_path(question)
      expect(page).to_not have_content I18n.t 'answers.edit.link'
    end
  end
end

require_relative '../feature_helper'

feature 'update answers', %q(
  In order to update answer
  Authorized user
  must be able to edit questions title and body
  ) do

  scenario 'Authorized user trying to update his question', js: true do
    question = create(:question, :with_answers)
    login_as(question.answers.first.user)
    visit question_path(question)
    click_on I18n.t 'answers.edit.link'
    within '#edit_answer' do
      fill_in 'Body', with: 'Alter answer body'
      click_on I18n.t 'answers.edit.button'
    end

    expect(page).to have_content I18n.t 'answers.update.success'
    expect(page).to have_content 'Alter answer body'
  end

  describe  'wrong user' do
    scenario 'Authorized user trying to update other user\'s question'
    scenario 'Unauthorized user trying to update question'
  end
end
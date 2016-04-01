require 'rails_helper'

feature 'delete answer', %q{
  In order to remove my answer from system
  As an authenticated user
  I want to be able to delete answer
} do
  given(:user) {create(:user)}
  given(:question) { create(:question, :with_answer) }

  scenario 'Authenticated user tries to delete answer he created' do
    login_as(question.answers.first.user, :scope => :user)
    visit question_path(question)
    click_on I18n.t('answers.delete.link')

    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('answers.delete.success')
  end

  scenario 'Authenticated user tries to delete answer of another user' do
    login_as(user, :scope => :user)
    visit question_path(question)

    expect(page).to_not have_link(
      I18n.t('questions.delete.link'),
      href: question_answer_path(question, question.answers.first)
    )
  end
  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link(
      I18n.t('questions.delete.link'),
      href: question_answer_path(question, question.answers.first)
    )
  end
end
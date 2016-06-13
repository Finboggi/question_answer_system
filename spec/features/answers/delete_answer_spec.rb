require_relative '../feature_helper'

feature 'delete answer', %q(
  In order to remove my answer from system
  As an authenticated user
  I want to be able to delete answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_answers, answers_count: 1) }
  given(:visit_question_not_author_check) do
    visit question_path(question)

    expect(page).to_not have_link(
      I18n.t('answers.delete.link'),
      href: question_answer_path(question, question.answers.first)
    )
  end

  scenario 'Authenticated user tries to delete answer he created', js: true do
    login_as(question.answers.first.user)
    visit question_path(question)
    answer_body = question.answers.first.body
    click_on I18n.t 'answers.delete.link'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t 'answers.delete.success'
    expect(page).to_not have_content answer_body
  end

  scenario 'Authenticated user tries to delete answer of another user' do
    login_as(user)
    visit_question_not_author_check
  end
  scenario 'Non-authenticated user tries to delete answer' do
    visit_question_not_author_check
  end
end

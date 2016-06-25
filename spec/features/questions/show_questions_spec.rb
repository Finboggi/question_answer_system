require_relative '../feature_helper'

feature 'show one question', %q(
  In order to work with question
  any user can see
  question page with list of answers
) do
  scenario 'user open #show page with answers' do
    question = create(:question, :with_answers)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    expect(page).to_not have_content I18n.t('attachments.plural')
    question.answers.each { |a| expect(page).to have_content a.body }
  end

  scenario 'user open #show page without answers' do
    question = create(:question)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content I18n.t('answers.none')
  end
end

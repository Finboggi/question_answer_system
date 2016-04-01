require 'rails_helper'

feature 'show all questions', %q(
  Any user
  Can see all questions
  ) do
  scenario 'user trying to see questions list' do
    questions = create_pair(:question)
    visit root_path

    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.second.title
    expect(page).to have_content I18n.t('questions.new.link')
  end

  scenario 'user trying to see questions list with no questions' do
    visit root_path
    expect(page).to have_content I18n.t('questions.none')
  end
end

feature 'show one question', %q(
  In order to work with question
  Any user can see
  question page with list of answers
) do
  scenario 'user open #show page with answers' do
    question = create(:question, :with_answers)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_button I18n.t('answers.new.button')
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

require_relative '../feature_helper'

feature 'show all questions', %q(
  Any user
  can see all questions
  ) do
  scenario 'user trying to see questions list' do
    questions = create_list(:question, 3)
    visit root_path

    questions.each { |q| expect(page).to have_content q.title }
    expect(page).to have_content I18n.t('questions.new.link')
  end

  scenario 'user trying to see questions list with no questions' do
    visit root_path
    expect(page).to have_content I18n.t('questions.none')
  end
end

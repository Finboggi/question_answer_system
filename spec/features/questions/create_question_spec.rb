require 'rails_helper'

feature 'create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  scenario 'authenticated user creates question' do
    sign_in(create(:user))

    visit questions_path
    click_on I18n.t 'ask_question_link'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'
    click_on 'Ask'

    expect(page).to have_content I18n.t 'question_created'
    # TODO: проверить что открылась страница с вопросом и там есть заголовок и тело вопроса
  end

  scenario 'Non-authenticated user creates question' do
    visit questions_path
    click_on I18n.t 'ask_question_link'

    expect(page).to have_content I18n.t 'devise.failure.unauthenticated'
  end
end

require_relative '../feature_helper'

feature 'create question', %q(
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
) do
  scenario 'authenticated user creates question' do
    login_as(create(:user))

    visit questions_path
    click_on I18n.t 'questions.new.link'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'
    click_on 'Ask'

    expect(page).to have_content I18n.t 'questions.new.success'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Text text'
  end

  scenario 'Non-authenticated user creates question' do
    visit questions_path
    click_on I18n.t 'questions.new.link'

    expect(page).to have_content I18n.t 'devise.failure.unauthenticated'
  end
end

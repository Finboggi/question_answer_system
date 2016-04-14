require 'rails_helper'

feature 'give answer', %q(
  In order to help other users
  as an authorised user
  I want to give answer to the existing question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user give answer', js: true do
    sign_in(user)
    answer = create(:answer)

    visit question_path(question)

    fill_in 'Body', with: answer.body
    click_on I18n.t('answers.new.button')

    within '.answers' do
      expect(page).to have_content answer.body
    end
  end

  scenario 'non-authenticated user sends answer' do
    visit question_path(question)
    expect(page).to_not have_css("button[value=\"#{I18n.t('answers.new.button')}\"]")
  end
end

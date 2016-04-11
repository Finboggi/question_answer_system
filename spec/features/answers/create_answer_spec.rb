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
    click_on I18n.t 'answers.new.button'

    # expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content answer.body
    end
    # expect(page).to have_content I18n.t 'answers.new.success'
  end

  # TODO: переписать этот фиче-тест
  scenario 'non-authenticated user sends answer' do
    visit new_question_answer_path(question)
    expect(page).to have_content I18n.t 'devise.failure.unauthenticated'
  end
end

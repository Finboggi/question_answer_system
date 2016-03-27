require 'rails_helper'

feature 'give answer', %q{
  In order to help other users
  as an authorised user
  I want to give answer to the existing question
} do

  given(:user) { create(:user) }

  scenario 'authenticated user give answer' do
    sign_in(user)

    question = create(:question)
    answer = create(:answer)

    visit new_question_answer_path(question)

    fill_in 'Body', with: answer.body
    click_on 'Give answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content answer.body
    expect(page).to have_content 'Answer successfully created'
  end

  scenario 'non-authenticated user sends answer' do
    question = create(:question)

    visit new_question_answer_path(question)
    expect(page).to have_content I18n.t 'devise.failure.unauthenticated'
  end

end


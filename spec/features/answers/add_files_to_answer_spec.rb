require_relative '../feature_helper'

feature 'add files to answer', %q(
  In order to illustrate my answer
  as answer's author
  I'd like to be able to attach files
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background { sign_in(user) }

  scenario 'User adds files when asks answer' do
    answer = build(:answer)

    visit question_path(question)

    fill_in 'Body', with: answer.body
    attach_file 'File', 'Gemfile.lock'

    click_on I18n.t('answers.new.button')

    within '.answers' do
      expect(page).to have_content 'Gemfile.lock', href: '/uploads/attachment/file/1/Gemfile.lock'
    end
  end

  scenario 'User adds files when update answer'
  scenario 'User deletes files attached to answer'
end

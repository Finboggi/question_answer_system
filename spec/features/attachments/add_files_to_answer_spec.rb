require_relative '../feature_helper'

feature 'add files to answer', %q(
  In order to illustrate my answer
  as answer's author
  I'd like to be able to attach files
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background { sign_in(user) }

  scenario 'User adds files when asks answer', js: true do
    answer = build(:answer)

    visit question_path(question)

    fill_in 'Body', with: answer.body
    all('.upload_file input[type="file"]').each do |input|
      # TODO: заменить на фикстуру файлов
      attach_file input[:name], 'Gemfile.lock'
    end

    click_on I18n.t('answers.new.button')

    expect(page).to have_link 'Gemfile.lock', href: '/uploads/attachment/file/1/Gemfile.lock'
  end

  scenario 'User adds files when update answer'
  scenario 'User deletes files attached to answer'
end

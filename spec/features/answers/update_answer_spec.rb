require_relative '../feature_helper'

feature 'update answers', %q(
  In order to update answer
  Authorized user
  must be able to edit questions title and body
  ) do
  given(:question) { create(:question, :with_answers) }
  given(:answer) { question.answers.first }
  given(:answer_not_owned) { question.answers.second }

  scenario 'Authorized user trying to update his question', js: true do
    login_as(answer.user)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on I18n.t 'answers.edit.link'
    end

    within '#edit_answer' do
      fill_in 'Body', with: 'Alter answer body'
      input = find '.upload_file input[type="file"]'
      attach_file input[:name], 'Gemfile.lock'
      click_on I18n.t 'answers.edit.button'
    end
    # TODO: разобраться почему браузер не видит заголовки при аяксе
    # TODO: вынести в отдельный сценарий загрузку файлов
    # expect(page).to have_content I18n.t 'answers.update.success'
    expect(page).to have_content 'Alter answer body'
    expect(page).to have_link 'Gemfile.lock', href: '/uploads/attachment/file/1/Gemfile.lock'

    within "#answer_#{answer.id}" do
      click_on I18n.t 'answers.edit.link'
    end

    within '#edit_answer' do
      input = find '.upload_file input[type="checkbox"]'
      check input.id
      click_on I18n.t 'answers.edit.button'
    end

    expect(page).to have_content I18n.t 'answers.update.success'
    expect(page).to_not have_link 'Gemfile.lock', href: '/uploads/attachment/file/1/Gemfile.lock'
  end

  describe 'wrong user' do
    scenario 'Authorized user trying to update other user\'s question' do
      login_as(answer.user)
      visit question_path(question)
      within "#answer_#{answer_not_owned.id}" do
        expect(page).to_not have_content I18n.t 'answers.edit.link'
      end
    end

    scenario 'Unauthorized user trying to update question' do
      visit question_path(question)
      expect(page).to_not have_content I18n.t 'answers.edit.link'
    end
  end
end

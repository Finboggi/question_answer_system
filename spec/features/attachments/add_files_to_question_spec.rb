require_relative '../feature_helper'

feature 'add files to question', %q(
  In order to illustrate my question
  as question's author
  I'd like to be able to attach files
) do

  scenario 'User adds files when asks question', js: true do
    question = build(:question)
    sign_in(create(:user))
    visit questions_path

    click_on I18n.t 'questions.new.link'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'
    2.times { click_link I18n.t('attachments.upload.add') }

    all('.upload_file input[type="file"]').each do |input|
      attach_file input[:name], 'Gemfile.lock'
    end

    click_on I18n.t('questions.new.button')

    expect(page).to have_link 'Gemfile.lock', href: '/uploads/attachment/file/1/Gemfile.lock'
  end

  scenario 'User adds files when update question', js: true do
    question = create(:question)
    login_as(question.user)
    visit question_path(question)

    click_on I18n.t 'questions.edit.link'

    within '#edit_question' do
      expect(page).to have_css '.upload_file input[type="file"]'

      all('.upload_file input[type="file"]').each do |input|
        attach_file input[:name], 'Gemfile.lock'
      end

      click_on I18n.t 'questions.edit.button'
    end

    expect(page).to have_link 'Gemfile.lock', href: '/uploads/attachment/file/1/Gemfile.lock'
  end

  scenario 'Authorized user trying to add file while updating his question', js: true do
    question = create(:question)
    login_as(question.user)
    visit question_path(question)

    click_on I18n.t 'questions.edit.link'

    within '#edit_question' do
      input = find '.upload_file input[type="file"]'
      attach_file input[:name], 'Gemfile.lock'
      click_on I18n.t 'questions.edit.button'
    end

    expect(page).to have_link 'Gemfile.lock', href: '/uploads/attachment/file/1/Gemfile.lock'
  end
end

require_relative '../feature_helper'

feature 'add files to question', %q(
  In order to illustrate my question
  as question's author
  I'd like to be able to attach files
) do
  given(:user) { create(:user) }
  given(:question) { build(:question) }

  background { sign_in(user) }

  scenario 'User adds files when asks question' do
    visit questions_path

    click_on I18n.t 'questions.new.link'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text'

    click_link I18n.t('attachments.add')

    all('.upload_file input[type="file"]').each do |input|
      attach_file input[:name], 'Gemfile.lock'
    end

    click_on I18n.t('questions.new.button')

    expect(page).to have_link 'Gemfile.lock', href: '/uploads/attachment/file/1/Gemfile.lock'
  end

  scenario 'User adds files when update question'
  scenario 'User can download added files (expect)'
  scenario 'Dont show attachments block if none uploaded'
  scenario 'User deletes files attached to question'
end

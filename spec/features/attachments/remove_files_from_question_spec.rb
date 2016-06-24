require_relative '../feature_helper'

feature 'remove files from question', %q(
  In order to manage list of attached to my question files
  as question's author
  I'd like to be able to remove files
) do
  given(:question) { create(:question, :with_attachments) }
  given(:attachment) { question.attachments.first }

  scenario 'Question\'s owner remove file', js: true do
    login_as(question.user)
    visit question_path(question)

    within '.attachments #attachment_' + attachment.id.to_s do
      click_on I18n.t('attachments.delete.link')
    end

    expect(page).to have_content I18n.t('attachments.delete.success')
    expect(page).to_not have_content attachment.file_identifier
  end

  scenario 'Not owner of the question tries to remove file' do
    login_as(create(:user))
    visit question_path(question)

    within '#question' do
      expect(page).to_not have_content I18n.t('attachments.delete.link')
    end
  end

  scenario 'Unauthorized user tries to remove file' do
    visit question_path(question)

    within '#question' do
      expect(page).to_not have_content I18n.t('attachments.delete.link')
    end
  end

  scenario 'Question\'s owner remove file via update', js: true do
    login_as(question.user)
    visit question_path(question)
    click_on I18n.t 'questions.edit.link'

    within "#update_attachment_#{attachment.id}" do
      find(:css, '.upload_file input[type="checkbox"]').set(true)
    end

    click_on I18n.t 'questions.edit.button'

    expect(page).to_not have_content attachment.file_identifier
    expect(page).to have_content I18n.t('questions.update.success')
  end
end

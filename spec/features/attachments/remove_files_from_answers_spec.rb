require_relative '../feature_helper'

feature 'remove files from question', %q(
  In order to manage list of attached to my question files
  as question's author
  I'd like to be able to remove files
) do
  given(:question) { create(:question, :with_answers, attach_files_to_answers: true) }
  given(:answer) { question.answers.first }
  given(:attachment) { question.answers.first.attachments.first }
  given(:attachment_not_owned) { question.answers.last.attachments.first }

  scenario 'Answers\'s owner remove file', js: true do
    login_as(attachment.attachable.user)
    visit question_path(question)

    within '.attachments #attachment_' + attachment.id.to_s do
      click_on I18n.t('attachments.delete.link')
    end

    expect(page).to have_content I18n.t('attachments.delete.success')
    expect(page).to_not have_content attachment.file_identifier
  end

  scenario 'Not owner of the answer tries to remove file' do
    login_as(attachment_not_owned.attachable.user)
    visit question_path(question)

    within '.attachments #attachment_' + attachment.id.to_s do
      expect(page).to_not have_content  I18n.t('attachments.delete.link')
    end
  end

  scenario 'Unauthorized user tries to remove file' do
    visit question_path(question)

    within '.attachments #attachment_' + attachment.id.to_s do
      expect(page).to_not have_content  I18n.t('attachments.delete.link')
    end
  end
end
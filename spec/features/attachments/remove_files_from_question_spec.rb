require_relative '../feature_helper'

feature 'remove files from question', %q(
  In order to manage list of attached to my question files
  as question's author
  I'd like to be able to remove files
) do
  given(:question) { create(:question, :with_attachments) }
  given(:attachment) { question.attachments.first }

  background { p question.attachments}

  scenario 'Question\'s owner remove file' do
    login_as(question.user)
    visit question_path(question)

    within '.attachments #attachment_' + attachment.id.to_s do
      click_on I18n.t('attachments.remove.link')
    end

    expect(page).to have_content I18n.t('attachments.remove.success')
    expect(page).to_not have_content attachment.file_identifier
  end

  scenario 'Not owner of the question tries to remove file'
  scenario 'Unauthorized user tries to remove file'
end
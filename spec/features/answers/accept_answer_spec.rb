require_relative '../feature_helper'

feature 'accept answer', %q(
  In order to mark correct answer
  Authorized author of the question
  must be able to accept answer
  ) do
  given(:question) { create(:question, :with_answers) }
  given(:answer) { question.answers.first }

  scenario 'Author of the question accepts answer', js: true do
    login_as(question.user)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on I18n.t('answers.accept.link')
      expect(page).to have_content  I18n.t('answers.accept.marker')
    end

    expect(page).to have_content I18n.t('answers.accept.success')
  end

  describe 'change answer acceptance' do
    before do
      answer.update(accepted: true)
      login_as(question.user)
      visit question_path(question)
    end

    scenario 'Author of the question remove rejects accepted answer', js: true do
      within "#answer_#{answer.id}" do
        click_on I18n.t('answers.reject.link')
        expect(page).to_not have_content  I18n.t('answers.accept.marker')
      end

      expect(page).to have_content I18n.t('answers.reject.success')
    end

    scenario 'Author of the question change accepted answer', js: true do
      within "#answer_#{question.answers.last.id}" do
        click_on I18n.t('answers.accept.link')
        expect(page).to have_content  I18n.t('answers.accept.marker')
      end

      expect(page).to have_content I18n.t('answers.accept.success')

      within "#answer_#{answer.id}" do
        expect(page).to_not have_content  I18n.t('answers.accept.marker')
      end
    end
  end
end
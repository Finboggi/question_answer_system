require_relative '../feature_helper'

feature 'accept answer', %q(
  In order to mark correct answer
  Authorized author of the question
  must be able to accept answer
  ) do
  describe 'set answer acceptance' do
    given(:question) { create(:question, :with_answers) }
    given(:answer) { question.answers.first }

    scenario 'Author of the question accepts answer', js: true do
      login_as(question.user)
      visit question_path(question)

      within "#answer_#{answer.id}" do
        click_on I18n.t('answers.accept.link')
        expect(page).to have_content I18n.t('answers.accept.marker')
      end

      expect(page).to have_content I18n.t('answers.accept.success')
      expect(first('.answers .answer')).to eq find("#answer_#{answer.id}")
    end
  end

  describe 'change answer acceptance' do
    given(:question) { create(:question, :with_answers, accepted_answer: true) }
    given(:answer) { question.answers.find { |a| !a.accepted } }
    given(:accepted_answer) { question.answers.find(&:accepted) }

    before do
      login_as(question.user)
      visit question_path(question)
    end

    scenario 'Author of the question remove rejects accepted answer', js: true do
      within "#answer_#{accepted_answer.id}" do
        click_on I18n.t('answers.reject.link')
        expect(page).to_not have_content I18n.t('answers.accept.marker')
      end

      expect(page).to have_content I18n.t('answers.reject.success')
    end

    scenario 'Author of the question change accepted answer', js: true do
      within "#answer_#{answer.id}" do
        click_on I18n.t('answers.accept.link')
        expect(page).to have_content I18n.t('answers.accept.marker')
      end

      within "#answer_#{accepted_answer.id}" do
        expect(page).to_not have_content I18n.t('answers.accept.marker')
      end

      expect(first('.answers .answer')).to eq find("#answer_#{answer.id}")
      expect(page).to have_content I18n.t('answers.accept.success')
    end
  end
end

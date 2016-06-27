require_relative '../feature_helper'

feature 'questions vote', %q(
  In order mark good or bad question
  Authorized user
  must be able to vote for or against question
  ) do
  # TODO: check votes count change
  describe 'User didn\'t voted yet' do
    given (:question) { create(:question) }

    scenario 'authorized user votes for other user\'s question', js: true do
      login_as(create(:user))
      visit question_path(question)

      within '#question' do
        click_on I18n.t('votes.for.link')
        expect(page).to have_content I18n.t('votes.for.marker')
      end

      expect(page).to have_content I18n.t('votes.for.success')
    end

    scenario 'authorized user votes against other user\'s question', js: true  do
      login_as(create(:user))
      visit question_path(question)

      within '#question' do
        click_on I18n.t('votes.for.link')
        expect(page).to have_content I18n.t('votes.against.marker')
      end

      expect(page).to have_content I18n.t('votes.against.success')
    end


    scenario 'authorized user votes for or against his question' do
      login_as(question.user)
      visit question_path(question)

      within '#question' do
        expect(page).to have_no_link I18n.t('votes.for.link')
        expect(page).to have_no_link I18n.t('votes.against.link')
      end
    end
    scenario 'unauthorized user votes for or against question' do
      visit question_path(question)

      within '#question' do
        expect(page).to have_no_link I18n.t('votes.for.link')
        expect(page).to have_no_link I18n.t('votes.against.link')
      end
    end

  end


  scenario 'authorized user withdraws his vote'
  scenario 'authorized user (not voted) withdraw'
  scenario 'unauthorized user tries to withdraw vote'
end
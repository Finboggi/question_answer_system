require_relative '../feature_helper'

feature 'questions vote', %q(
  In order mark good or bad question
  Authorized user
  must be able to vote for or against question
  ) do
  describe 'User didn\'t voted yet' do
    given(:question) { create(:question) }

    scenario 'authorized user votes for other user\'s question', js: true do
      login_as(create(:user))
      visit question_path(question)
      votes_sum = nil

      within '#question' do
        votes_sum = find('.votes_sum .numeric').text.to_i
        click_on I18n.t('votes.for.link')
        expect(page).to have_content I18n.t('votes.for.marker')
      end

      expect(page).to have_content I18n.t('votes.for.success')

      within '#question' do
        expect_no_vote_links
        expect(find('.votes_sum .numeric').text.to_i).to eq(votes_sum + 1)
      end
    end

    scenario 'authorized user votes against other user\'s question', js: true do
      login_as(create(:user))
      visit question_path(question)
      votes_sum = nil

      within '#question' do
        votes_sum = find('.votes_sum .numeric').text.to_i
        click_on I18n.t('votes.against.link')
        expect(page).to have_content I18n.t('votes.against.marker')
      end

      expect(page).to have_content I18n.t('votes.against.success')

      within '#question' do
        expect_no_vote_links
        expect(find('.votes_sum .numeric').text.to_i).to eq(votes_sum - 1)
      end
    end

    scenario 'authorized user votes for or against his question' do
      login_as(question.user)
      visit question_path(question)

      within '#question' do
        expect_no_vote_links
      end
    end

    scenario 'unauthorized user votes for or against question' do
      visit question_path(question)

      within '#question' do
        expect_no_vote_links
      end
    end
  end

  describe 'vote withdrawing' do
    given(:question) { create(:question, :with_votes) }

    scenario 'authorized user withdraws his vote', js: true do
      login_as(question.votes.first.user)
      visit question_path(question)

      within '#question' do
        click_on I18n.t('votes.unvote.link')
        expect(page).to have_link I18n.t('votes.for.link')
        expect(page).to have_link I18n.t('votes.against.link')
      end

      expect(page).to have_content I18n.t('votes.unvote.success')
    end

    scenario 'authorized user (not voted) withdraw', js: true do
      login_as(create(:user))
      visit question_path(question)

      within '#question' do
        expect(page).to have_no_link I18n.t('votes.unvote.link')
      end
    end

    scenario 'unauthorized user tries to withdraw vote' do
      visit question_path(question)

      within '#question' do
        expect(page).to have_no_link I18n.t('votes.unvote.link')
      end
    end
  end
end

require_relative '../feature_helper'

feature 'answers vote', %q(
  In order mark good or bad answers
  Authorized user
  must be able to vote for or against answers
  ) do
  describe 'User didn\'t voted yet' do
    given(:question) { create(:question, :with_answers) }
    given(:answer) { question.answers.first }

    scenario 'authorized user votes for other user\'s question', js: true do
      login_as(create(:user))
      visit question_path(question)
      votes_sum = nil

      within '#answer_' + answer.id.to_s do
        votes_sum = find('.votes_sum .numeric').text.to_i
        click_on I18n.t('votes.for.link')
        expect(page).to have_content I18n.t('votes.for.marker')
      end

      expect(page).to have_content I18n.t('votes.for.success')

      within '#answer_' + answer.id.to_s do
        expect_no_vote_links
        expect(find('.votes_sum .numeric').text.to_i).to eq(votes_sum+1)
      end
    end

    scenario 'authorized user votes against other user\'s question', js: true  do
      login_as(create(:user))
      visit question_path(question)
      votes_sum = nil

      within '#answer_' + answer.id.to_s do
        votes_sum = find('.votes_sum .numeric').text.to_i
        click_on I18n.t('votes.against.link')
        expect(page).to have_content I18n.t('votes.against.marker')
      end

      expect(page).to have_content I18n.t('votes.against.success')

      within '#answer_' + answer.id.to_s do
        expect_no_vote_links
        expect(find('.votes_sum .numeric').text.to_i).to eq(votes_sum-1)
      end
    end


    scenario 'authorized user votes for or against his question' do
      login_as(answer.user)
      visit question_path(question)

      within '#answer_' + answer.id.to_s do
        expect_no_vote_links
      end
    end

    scenario 'unauthorized user votes for or against question' do
      visit question_path(question)

      within '#answer_' + answer.id.to_s do
        expect_no_vote_links
      end
    end
  end

  describe 'vote withdrawing' do
    given (:question) { create(:question, :with_answers) }
    given(:answer) { question.answers.first }
    given(:vote) { create(:vote, {votable_id: answer.id, votable_type: answer.class.name}) }

    scenario 'authorized user withdraws his vote', js: true do
      login_as(vote.user)
      visit question_path(question)

      within '#answer_' + answer.id.to_s do
        click_on I18n.t('votes.unvote.link')
        expect(page).to have_link I18n.t('votes.for.link')
        expect(page).to have_link I18n.t('votes.against.link')
      end

      expect(page).to have_content I18n.t('votes.unvote.success')
    end

    scenario 'authorized user (not voted) withdraw', js: true do
      login_as(create(:user))
      visit question_path(question)

      within '#answer_' + answer.id.to_s do
        expect(page).to have_no_link I18n.t('votes.unvote.link')
      end
    end

    scenario 'unauthorized user tries to withdraw vote' do
      visit question_path(question)

      within '#answer_' + answer.id.to_s do
        expect(page).to have_no_link I18n.t('votes.unvote.link')
      end
    end
  end
end

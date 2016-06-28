module VotesHelper
  def voted_marker(votable)
    (votable.voted_for? current_user) ? t('votes.for.marker') : t('votes.against.marker')
  end
end

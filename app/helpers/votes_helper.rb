module VotesHelper
  def voted_marker(votable)
    (votable.voted_for? current_user) ? t('votes.for.marker') : t('votes.against.marker')
  end

  def vote_url_json(votable)
    polymorphic_url([votable, :vote], :format => :json)
  end

  def unvote_url_json(votable)
    polymorphic_url([votable, :unvote], :format => :json)
  end
end

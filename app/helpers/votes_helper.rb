module VotesHelper
  def voted_marker(votable)
    if current_user.voted? votable
      (current_user.voted_for? votable) ? t('votes.for.marker') : t('votes.against.marker')

    end
  end

  def vote_for_url_json(votable)
    polymorphic_url(path_array(votable, :vote_for), format: :json)
  end

  def vote_against_url_json(votable)
    polymorphic_url(path_array(votable, :vote_against), format: :json)
  end

  def unvote_url_json(votable)
    polymorphic_url(path_array(votable, :unvote), format: :json)
  end

  private

  def path_array(votable, vote_method)
    result = []
    result << votable.question if votable.class.name == 'Answer'
    result << votable
    result << vote_method
  end
end

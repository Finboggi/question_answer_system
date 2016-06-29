module VotesHelper
  def voted_marker(votable)
    (votable.voted_for? current_user) ? t('votes.for.marker') : t('votes.against.marker')
  end

  def vote_url_json(votable)
    polymorphic_url(path_array(votable, :vote), :format => :json)
  end

  def unvote_url_json(votable)
    polymorphic_url(path_array(votable, :unvote), :format => :json)
  end

  private

  def path_array(votable, vote_method)
    result = []
    result << votable.question if votable.class.name == 'Answer'
    result << votable
    result << vote_method
  end
end

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_for(user)
    vote = votes.new(user: user, value: 1)
    vote.save
    vote
  end

  def vote_against(user)
    vote = votes.new(user: user, value: -1)
    vote.save
    vote
  end

  def votes_sum
    votes.sum :value
  end
end

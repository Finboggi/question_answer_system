module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def user_vote(user)
    votes.where(user: user, votable: self).first
  end

  def votes_sum
    votes.sum :value
  end

  def voted?(user)
    user_vote(user).present?
  end

  def not_voted?(user)
    !voted? user
  end

  def voted_for?(user)
    voted?(user) && user_vote(user).positive?
  end

  def voted_against?(user)
    !voted_for? user
  end
end

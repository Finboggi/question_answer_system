module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  private

  def current_user_vote
    self.votes.where( { user: current_user } )
  end
end
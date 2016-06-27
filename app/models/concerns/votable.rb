module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def votes_sum
    Vote.where( { votable: self } ).sum(:value)
  end
end

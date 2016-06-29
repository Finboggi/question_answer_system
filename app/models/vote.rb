class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, uniqueness: { scope: :votable,
                                    message: ' can vote only once per votable object' }
  validate :not_from_votable_author

  private

  def not_from_votable_author
    if user_id == votable.user_id
      errors.add(:too_many_accepted, 'user cannot vote for owned votable objects')
    end
  end
end

class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user
  before_save :normalize_value

  validates :user, uniqueness: { scope: :votable,
                                 message: ' can vote only once per votable object'
  }
  validate :not_from_votable_author

  def positive?
    value >= 0
  end

  def nagative?
    !positive?
  end

  private

  def not_from_votable_author
    if user_id == votable.user_id
      errors.add(:too_many_accepted, 'user cannot vote for owned votable objects')
    end
  end

  def normalize_value
    positive? ? 1 : -1
  end
end

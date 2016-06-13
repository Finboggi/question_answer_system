class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  scope :accepted, -> { where(accepted: true) }
  scope :same_question, -> (question_id) { where question_id: question_id }

  validates :body, :question_id, :user_id, presence: true
  validate :only_one_accepted

  def change_acceptance
    unaccept_all if accepted
    self.update(accepted: !accepted)
    self
  end

  private
  def unaccept_all
    Answer.same_question(question_id).accepted.update_all(accepted: false)
  end

  def only_one_accepted
    if accepted && Answer.same_question(question_id).accepted.count > 1
      errors.add(:too_many_accepted, 'only one accepted answer for each question')
    end
  end
end

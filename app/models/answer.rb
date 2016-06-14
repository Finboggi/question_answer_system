class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  default_scope { order('accepted DESC, created_at DESC') }
  scope :accepted, -> { where(accepted: true) }
  scope :same_question, -> (question_id) { where question_id: question_id }

  validates :body, :question_id, :user_id, presence: true
  validate :only_one_accepted

  def change_acceptance
    unaccept_all_but_current unless accepted
    update(accepted: !accepted)
    self
  end

  private

  def unaccept_all_but_current
    Answer.same_question(question_id).accepted.where.not(id: id).update_all(accepted: false)
  end

  def only_one_accepted
    if accepted && Answer.same_question(question_id).accepted.count > 1
      errors.add(:too_many_accepted, 'only one accepted answer for each question')
    end
  end
end

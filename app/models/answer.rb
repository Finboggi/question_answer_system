class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  scope :same_question, -> (question_id) { where question_id: question_id }
  scope :only_one_accepted, on: :update, if: 'accepted'

  validates :body, :question_id, :user_id, presence: true
  validates :accepted, uniqueness: { scope: :year,
                                 message: "should happen once per year" }

  def change_acceptance(accepted)
    unaccept_all
    self.update(accepted: true) if accepted == 'true' || accepted === true
    self
  end

  private
  def unaccept_all
    Answer.same_question(question_id).where(accepted: true).update_all(accepted: false)
  end

  def only_one_accepted
    if accepted && Answer.same_question.accepted.count > 1
      errors.add(:too_many_accepted, "only one accepted answer for each question")
    end
  end
end

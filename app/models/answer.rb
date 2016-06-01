class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  scope :same_question, -> (question_id) { where(question_id: question_id) }

  def change_acceptance(accepted)
    unaccept_all
    self.update(accepted: true) if accepted == 'true' || accepted === true
    self
  end

  private
  def unaccept_all()
    Answer.same_question(question_id).where(accepted: true).update_all(accepted: false)
  end
end

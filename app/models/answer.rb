class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  default_scope { order('accepted DESC, created_at DESC') }
  scope :accepted, -> { where(accepted: true) }
  scope :same_question, -> (question_id) { where question_id: question_id }

  validates :body, :question_id, :user_id, presence: true
  validate :only_one_accepted

  accepts_nested_attributes_for :attachments, allow_destroy: true,
                                reject_if: :all_blank

  def change_acceptance
    Answer.transaction do
      unaccept_all_but_current! unless accepted
      update!(accepted: !accepted)
    end

    self
  end

  private

  def unaccept_all_but_current!
    Answer.same_question(question_id).accepted.where.not(id: id).update_all(accepted: false)
  end

  def only_one_accepted
    if accepted && Answer.same_question(question_id).accepted.present?
      errors.add(:too_many_accepted, 'only one accepted answer for each question')
    end
  end
end

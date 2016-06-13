require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it 'allows only one accepted answer for question' do
    question = create(:question, :with_answers, accepted_answer: true)
    answer = question.answers.find { |a| !a.accepted }
    answer.accepted = true
    answer.save!
    answer.valid?

    expect(answer.errors.full_messages)
      .to include('Too many accepted only one accepted answer for each question')
  end
end

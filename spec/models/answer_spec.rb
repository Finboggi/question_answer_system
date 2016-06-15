require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it 'allows accept one answer' do
    question = create(:question, :with_answers)
    answer = question.answers.find { |a| !a.accepted }
    answer.accepted = true
    answer.valid?

    expect(answer.errors.full_messages).to eq []
  end

  it 'allows only one accepted answer for question' do
    question = create(:question, :with_answers, accepted_answer: true)
    answer = question.answers.find { |a| !a.accepted }
    answer.accepted = true
    answer.valid?

    expect(answer.errors.full_messages)
      .to include('Too many accepted only one accepted answer for each question')
  end

  describe 'default scope' do
    let!(:answer_one) { create(:answer, accepted: false) }
    let!(:answer_two) { create(:answer, accepted: true) }

    it 'is sorted by acceptance' do
      expect(Answer.all).to eq [answer_two, answer_one]
    end
  end
end

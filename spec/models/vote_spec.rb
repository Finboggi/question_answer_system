require 'anonymous_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  describe 'votable relation validations' do
    with_model :VoteContainer do
      table do |t|
        t.belongs_to :user
      end

      model do
        include Votable
      end
    end

    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:instanced_model) { VoteContainer.create!(user_id: user.id) }

    it 'allows to save one vote to not owner of votable object' do
      vote = instanced_model.votes.build(user_id: another_user.id, value: 1)
      vote.valid?

      expect(vote.errors.full_messages).to eq []
    end

    it 'validates only one vote form user on votable object' do
      instanced_model.votes.create(user_id: another_user.id, value: 1)
      vote = instanced_model.votes.build(user_id: another_user.id, value: 1)
      vote.valid?

      expect(vote.errors.full_messages).to_not eq []
    end

    it 'rejects saving votes from owner of votable object' do
      vote = instanced_model.votes.build(user_id: user.id, value: 1)
      vote.valid?

      expect(vote.errors.full_messages).to_not eq []
    end
  end
end

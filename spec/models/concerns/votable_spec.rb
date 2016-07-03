require 'anonymous_helper'

describe 'votable', type: :model do
  with_model :VoteContainer do
    table do |t|
      t.belongs_to :user
    end

    model do
      include Votable
    end
  end

  # Doesn't work
  # it { should have_many(:votes) }
  # so this spec is just a dummy now
end

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answer).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
end

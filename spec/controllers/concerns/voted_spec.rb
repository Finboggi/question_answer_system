require 'anonymous_helper'

describe ApplicationController, type: :controller do
  with_model :Anonymou do
    table do |t|
      t.references :user
    end

    model do
      include Votable
      belongs_to :user
    end
  end

  controller do
    include Voted
  end

  describe 'POST#vote' do
    create_user_and_sign_in
    let(:another_user) { create(:user) }
    let(:model_instance) { Anonymou.create( { user: another_user } ) }
    let(:params) { { format: 'json', anonymou_id: model_instance.id, vote: { value: 1 } } }
    before { routes.draw { post 'vote' => "anonymous#vote" } }

    it 'adds vote to database and assigns it to model instance' do
      expect { post :vote, params }
          .to change(model_instance.votes, :count).by(1)
    end

    it 'changes votes sum by 1' do
      votes_sum = model_instance.votes_sum
      post :vote, params
      expect(model_instance.votes_sum).to eq(votes_sum + 1)
    end

    it 'user authors new vote' do
      post :vote, params
      expect(assigns(:vote).user_id).to eq @user.id
    end

    it 'flashes no alerts' do
      expect(flash[:alert]).to be_nil
    end
  end
end
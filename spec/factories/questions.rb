FactoryGirl.define do
  factory :question do
    title 'MyString'
    body 'MyText'
    association :user, factory: :user

    transient do
      answering_user nil
    end

    trait :with_answer do
      after(:create) do |question, evaluator|
        params_hash = {question_id: question.id}
        params_hash[:user] = evaluator.answering_user unless evaluator.answering_user.nil?
        create(:answer, params_hash)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title 'MyString'
    body ''
    association :user, :factory => :user
  end
end

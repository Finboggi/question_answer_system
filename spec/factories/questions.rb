FactoryGirl.define do
  sequence(:title) { |n| "MyTitle #{n}" }
  sequence(:body) { |n| "MyBody #{n}" }

  factory :question do
    title
    body
    user

    transient do
      answering_user nil
      answers_count 2
    end

    trait :with_answers do
      after(:create) do |question, evaluator|
        params_hash = {question_id: question.id}
        params_hash[:user] = evaluator.answering_user unless evaluator.answering_user.nil?
        create_list(:answer, evaluator.answers_count, params_hash)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title 'MyString'
    body ''
    association :user, :factory => :user
  end
end

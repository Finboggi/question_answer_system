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
      accepted_answer false
      attach_files_to_answers false
      attachments_count 2
    end

    trait :with_votes do
      after(:create) do |question, evaluator|
        params_hash = { votable_id: question.id, votable_type: question.class.name }
        create_list(:vote, 2, params_hash)
      end
    end

    trait :with_answers_and_attachments do
      with_answers
      with_attachments
    end

    trait :with_answers do
      after(:create) do |question, evaluator|
        params_hash = { question_id: question.id }
        params_hash[:user] = evaluator.answering_user unless evaluator.answering_user.nil?

        answer_traits = []
        answer_traits << :with_attachments if evaluator.attach_files_to_answers

        answers_count = evaluator.answers_count
        answers_count += 1 if evaluator.accepted_answer && evaluator.answers_count > 1

        create_list(:answer, answers_count, * answer_traits + [params_hash])

        if evaluator.accepted_answer
          params_hash[:accepted] = true
          create(:answer, * answer_traits + [params_hash])
        end
      end
    end

    trait :with_attachments do
      after(:create) do |question, evaluator|
        params_hash = { attachable_id: question.id, attachable_type: question.class.name }
        create_list(:attachment, evaluator.attachments_count, params_hash)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title 'MyString'
    body ''
    association :user, factory: :user
  end
end

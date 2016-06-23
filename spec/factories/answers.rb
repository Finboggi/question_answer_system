FactoryGirl.define do
  factory :answer do
    body
    question
    user
    accepted false

    transient do
      attachments_count 2
    end

    trait :with_attachments do
      after(:create) do |answer, evaluator|
        params_hash = { attachable_id: answer.id, attachable_type: answer.class.name }

        create_list(:attachment, evaluator.attachments_count, params_hash)
      end
    end
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end

FactoryGirl.define do
  factory :answer do
    body 'MyAnswer'
    association :question, :factory => :question
    association :user, factory: :user
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end

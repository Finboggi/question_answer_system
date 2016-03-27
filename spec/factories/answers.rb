FactoryGirl.define do
  factory :answer do
    body 'MyAnswer'
    association :question, :factory => :question
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end

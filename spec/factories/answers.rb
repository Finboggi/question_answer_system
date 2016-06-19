FactoryGirl.define do
  factory :answer do
    body
    question
    user
    accepted false
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end

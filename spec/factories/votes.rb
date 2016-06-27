FactoryGirl.define do
  factory :vote do
    user
    votable ""
    value 1
  end
end

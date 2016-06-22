FactoryGirl.define do
  sequence(:file) { |n| "MyString_#{n}" }

  factory :attachment do
    file
  end
end

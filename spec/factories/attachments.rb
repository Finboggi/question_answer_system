FactoryGirl.define do
  sequence(:file_name) { |n| "MyFileName_#{n}" }

  factory :attachment do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'Gemfile')) }
    after :create do |b|
      b.update_column(:file, generate(:file_name))
    end
  end
end

# frozen_string_literal: true

FactoryGirl.define do
  factory :question do
    key Faker::Lorem.word
    label Faker::Lorem.word
    content Faker::Lorem.sentence
    question_type 'string'
    validate_as Faker::Lorem.word
    association :section, factory: :section

    trait :with_choices do
      after(:create) do |question|
        create_list(:choice, 3, question: question)
      end
    end
  end
end

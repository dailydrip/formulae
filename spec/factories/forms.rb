# frozen_string_literal: true

FactoryGirl.define do
  factory :form do
    association :application, factory: :application
    completion_content Faker::Lorem.word
    after(:create) do |form|
      s1, s2, s3 = FactoryGirl.create_list(:section, 3, form: form)
      # Creating Questions for the sections
      FactoryGirl.create(:question, section: s1)
      FactoryGirl.create(:question, section: s2)
      FactoryGirl.create(:question, section: s3)
    end

    trait :with_questions_and_choices do
      after(:create) do |form|
        form.questions.map do |q|
          q.choices << FactoryGirl.create_list(:choice, 2, question: q)
        end
      end
    end
  end
end

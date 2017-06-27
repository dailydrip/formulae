# frozen_string_literal: true

FactoryGirl.define do
  factory :application do
    api_keys { [FactoryGirl.create(:api_key)] }
  end
end

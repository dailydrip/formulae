# frozen_string_literal: true

class Application < ApplicationRecord
  has_many :api_keys
  has_many :forms

  def self.authorize(api_key)
    ApiKey.find_by(token: api_key)
  end
end

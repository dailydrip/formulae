# frozen_string_literal: true

class ApiKey < ApplicationRecord
  belongs_to :application
  validates :token, uniqueness: true
  before_create :set_token

  private def set_token
    self.token = SecureRandom.uuid
  end
end

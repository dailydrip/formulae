# frozen_string_literal: true

class Application < ApplicationRecord
  has_many :api_keys

  def authorize(application_id, api_key)
    # FIXME:
    # Iterate over api_keys and check if one of them can be authorized
    true
  end
end

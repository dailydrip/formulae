# frozen_string_literal: true

class Api::V1::ApiController < AuthorizedController
  skip_before_action :verify_authenticity_token
end

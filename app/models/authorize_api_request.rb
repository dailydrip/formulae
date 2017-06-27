# frozen_string_literal: true

class AuthorizeApiRequest
  prepend SimpleCommand

  attr_reader :headers

  def initialize(headers = {})
    @headers = headers
  end

  def call
    authorize_request
  end

  def authorize_request
    authorized = Application.authorize(api_key_from_header)
    authorized || errors.add(:token, 'Not Authorized')
  end

  private def api_key_from_header
    authorization = headers['Authorization']
    # Example: Authorization: Bearer some_api_key
    return authorization.split(' ').last if authorization
    errors.add(:token, 'Missing Authorization')
    nil
  end
end

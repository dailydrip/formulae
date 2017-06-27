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
    authorized ||= Application.authorize(application_id_from_header, api_key_from_header)
    authorized || errors.add(:token, 'Not Authorized')
  end

  private def application_id_from_header
    if headers['application_id'].present?
      return headers['application_id'].split(' ').last
    else
      errors.add(:token, 'Missing Application Id')
    end
    nil
  end

  private def api_key_from_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end
    nil
  end
end

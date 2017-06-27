# frozen_string_literal: true

class AuthorizedController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_request

  private def authenticate_request
    request = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless request
  end
end

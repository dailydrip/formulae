# frozen_string_literal: true

class AuthorizedController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_request

  private def authenticate_request
    command = AuthorizeApiRequest.call(request.headers)
    if command.success?
      api_key = command.result
      @application = api_key.application
    else
      render json: { error: 'Not Authorized' }, status: 401 && return
    end
  end
end

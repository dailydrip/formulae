# frozen_string_literal: true

class AuthorizedController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_request

  private def authenticate_request
    command = AuthorizeApiRequest.call(request.headers)
    if command.success?
      api_key = command.result
      render_no_application(api_key)
      @application = api_key.application
    else
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  private def render_no_application(api_key)
    render json: { error: 'There is no application for this Api Key' }, status: 500 if api_key.application.nil?
  end
end

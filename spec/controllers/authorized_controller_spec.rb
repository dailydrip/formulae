# frozen_string_literal: true

require 'rails_helper'

# General tests for our Authorized Controller
RSpec.describe AuthorizedController, type: :request do
  describe 'Unauthorized' do
    context 'when we hit the api via form submissions' do
      it 'returns 401 when the token is wrong' do
        post api_v1_form_submissions_path,
             params: {
               form_submission: { form_id: 1,
                                  question_submissions: [] }
             }, headers: { Authorization: 'Bearer WRONG_TOKEN' }
        resp = JSON.parse(response.body)
        expect(resp.keys).to eq %w[error]
        expect(resp['error']).to eq 'Not Authorized'
        expect(response.status).to eq 401
      end
    end
  end

  describe 'No Application' do
    let(:api_key) { FactoryGirl.create(:api_key) }
    let(:authorization) { "Bearer #{api_key.token}" }

    context 'when we hit the api via form submissions' do
      it 'returns 500 when there is not application' do
        post api_v1_form_submissions_path,
             params: {
               form_submission: { form_id: 1,
                                  question_submissions: [] }
             }, headers: { Authorization: authorization }
        resp = JSON.parse(response.body)
        expect(resp.keys).to eq %w[error]
        expect(resp['error']).to eq 'There is no application for this Api Key'
        expect(response.status).to eq 500
      end
    end
  end
end

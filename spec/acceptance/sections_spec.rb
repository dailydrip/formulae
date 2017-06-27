# frozen_string_literal: true

require 'spec_helper'
require 'acceptance_helper'

resource 'Sections' do
  let(:authorization) { nil }

  header 'Content-Type', 'application/json'
  header 'Authorization', :authorization

  context 'When Authorized' do
    let(:section) { FactoryGirl.create(:section) }
    let(:api_key) { section.form.application.api_keys.first }
    let(:authorization) { "Bearer #{api_key.token}" }
    let(:id) { section.id }

    get 'api/v1/sections/:id' do
      example 'Listing Sections' do
        do_request
        expect(status).to eq 200
      end
    end

    get 'api/v1/sections/:id' do
      example 'Getting a specific Section' do
        do_request

        response = JSON.parse(response_body)
        expect(response.keys).to eq %w[id form_id name order content created_at updated_at]
        expect(status).to eq 200
      end
    end

    put 'api/v1/sections/:id' do
      parameter :name, scope: :section
      let(:new_value) { 'name updated' }
      let(:name) { new_value }

      example_request 'Updating a Section' do
        response = JSON.parse(response_body)
        expect(response['name']). to eq new_value
        expect(status).to eq(200)
      end
    end

    post 'api/v1/forms/:form_id/sections' do
      parameter :form_id, scope: :section
      parameter :name, scope: :section
      parameter :content, scope: :section

      let(:name) { section.name }
      let(:content) { section.content }
      let(:form_id) { section.form_id }

      example_request 'Creating a new Section' do
        response = JSON.parse(response_body)
        expect(response.keys).to eq %w[id form_id name order content created_at updated_at]
        expect(status).to eq(201)
      end
    end

    delete 'api/v1/sections/:id' do
      example_request 'Deleting a Section' do
        expect(status).to eq(204)
      end
    end
  end

  context 'When Unauthorized' do
    post 'api/v1/forms/:form_id/sections' do
      example_request 'Creating a new Section' do
        response = JSON.parse(response_body)
        expect(response.keys).to eq %w[error]
        expect(response['error']). to eq 'Not Authorized'
        expect(status).to eq(401)
      end
    end

    get 'api/v1/sections/:id' do
      example 'Listing Sections' do
        do_request
        expect(status).to eq 401
      end
    end
  end
end

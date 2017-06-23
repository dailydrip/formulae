# frozen_string_literal: true

require 'spec_helper'
require 'acceptance_helper'

resource 'Forms' do
  header 'Content-Type', 'application/json'

  let!(:form_object) { FactoryGirl.create(:form, :with_questions_and_choices) }

  post '/api/v1/forms' do
    let(:new_form_object) { FormMethods.build_a_new_form }

    let(:form) { FormMethods.create_params_for(new_form_object) }

    parameter :form

    example_request 'Creating a Form' do
      response = JSON.parse(response_body)
      expect(response.keys).to eq %w[id application completion_content sections questions]
      expect(response['application']['id']).to eq new_form_object.application_id
      expect(status).to eq(201)
    end
  end

  post '/api/v1/forms' do
    let(:new_completion_content) { 'New Completion Content' }
    let(:form) do
      updated_form = FormMethods.create_params_for(form_object)
      updated_form[:completion_content] = new_completion_content
      updated_form
    end

    parameter :form

    example_request 'Updating a Form' do
      response = JSON.parse(response_body)
      expect(response.keys).to eq %w[id application completion_content sections questions]
      expect(response['id']).to eq form_object.id
      expect(response['completion_content']).to eq new_completion_content
      expect(response['application']['id']).to eq form_object.application_id
      expect(status).to eq(200)
    end
  end

  get 'api/v1/forms' do
    example 'Listing Forms' do
      do_request
      response = JSON.parse(response_body)
      expect(response.first.keys).to eq %w[id application completion_content sections questions]
      expect(status).to eq 200
    end
  end

  get 'api/v1/forms/:id' do
    let(:id) { form_object.id }

    example 'Getting a specific Form' do
      do_request

      response = JSON.parse(response_body)
      expect(response.keys).to eq %w[id application completion_content sections questions]
      expect(status).to eq 200
    end
  end

  delete 'api/v1/forms/:id' do
    let(:id) { form_object.id }

    example_request 'Deleting a form' do
      expect(status).to eq(204)
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'
require 'acceptance_helper'

resource 'Forms' do
  header 'Content-Type', 'application/json'

  let!(:form) { FactoryGirl.create(:form, :with_questions_and_choices) }

  get 'api/v1/forms' do
    example 'Listing Forms' do
      do_request
      response = JSON.parse(response_body)
      expect(response.first.keys).to eq %w[id application completion_content sections questions]
      expect(status).to eq 200
    end
  end

  get 'api/v1/forms/:id' do
    let(:id) { form.id }

    example 'Getting a specific Form' do
      do_request

      response = JSON.parse(response_body)
      expect(response.keys).to eq %w[id application completion_content sections questions]
      expect(status).to eq 200
    end
  end

  delete 'api/v1/forms/:id' do
    let(:id) { form.id }

    example_request 'Deleting a form' do
      expect(status).to eq(204)
    end
  end
end

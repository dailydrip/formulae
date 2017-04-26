# frozen_string_literal: true

require 'spec_helper'
require 'acceptance_helper'

resource 'Questions' do
  header 'Content-Type', 'application/json'

  let(:form) { FactoryGirl.create(:form) }

  get 'api/v1/forms' do
    example 'Listing Forms' do
      do_request
      expect(status).to eq 200
    end
  end

  get 'api/v1/forms/:id' do
    let(:id) { form.id }

    example 'Getting a specific Form' do
      do_request

      response = JSON.parse(response_body)
      expect(response['id']). to eq q.id
      expect(response['key']). to eq q.key
      expect(response['label']). to eq q.label
      expect(response['content']). to eq q.content
      expect(response['order']). to eq q.order
      expect(response['hidden']). to eq q.hidden
      expect(response['question_type']). to eq q.question_type
      expect(response['validate_as']). to eq q.validate_as
      expect(status).to eq 200
    end
  end

  put 'api/v1/forms/:id' do
    let(:new_value) { 'updated' }
    let(:raw_post) do
      {
        question: {
          key: new_value
        }
      }.to_json
    end

    let(:form_id) { q.form.id }
    let(:id) { q.id }

    example_request 'Updating a form' do
      response = JSON.parse(response_body)
      expect(response['label']). to eq q.label
      expect(response['key']). to eq new_value
      expect(status).to eq(200)
    end
  end

  delete 'api/v1/forms/:form_id/questions/:id' do
    let(:id) { form.id }

    example_request 'Deleting a form' do
      expect(status).to eq(204)
    end
  end
end

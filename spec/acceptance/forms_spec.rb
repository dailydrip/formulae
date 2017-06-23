# frozen_string_literal: true

require 'spec_helper'
require 'acceptance_helper'

resource 'Forms' do
  header 'Content-Type', 'application/json'

  let!(:form_object) { FactoryGirl.create(:form, :with_questions_and_choices) }

  post '/api/v1/forms' do
    let(:new_form) do
      build_form = FactoryGirl.build(:form)
      build_form.sections = FactoryGirl.build_list(:section, 3, form: build_form)
      build_form.sections.each do |section|
        section.questions << FactoryGirl.build(:question)
      end
      build_form
    end

    let(:form) do
      desired_hash = {}
      desired_hash = new_form.slice(:id, :completion_content, :application_id)
      new_form.sections.map do |section|
        section_value = section.slice(:id, :form_id, :name, :order, :content, :_destroy)
        desired_hash[:sections] = []
        desired_hash[:sections] << section_value

        desired_hash[:sections].each do |sections_params|
          questions_for_section = section.questions.map do |q|
            q.slice(:id, :key, :label, :content, :order, :hidden,
                    :question_type, :validate_as, :section_id, :required,
                    :placeholder, :_destroy)
          end
          sections_params[:questions] = []
          sections_params[:questions] = questions_for_section
        end
      end
      desired_hash
    end

    parameter :form

    example_request 'Creating a form' do
      response = JSON.parse(response_body)
      expect(response.keys).to eq %w[id application completion_content sections questions]
      expect(response['application']['id']).to eq new_form.application_id
      expect(status).to eq(201)
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

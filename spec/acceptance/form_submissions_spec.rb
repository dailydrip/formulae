# frozen_string_literal: true

require 'spec_helper'
require 'acceptance_helper'

resource 'Form Submissions' do
  header 'Content-Type', 'application/json'

  let(:form_submission) { FactoryGirl.create(:form_submission) }
  let(:id) { form_submission.id }

  get '/api/v1/form_submissions/:id' do
    example 'Listing All Questions Submissions' do
      do_request
      expect(status).to eq 200
    end
  end

  get '/api/v1/form_submissions/:id' do
    example 'Getting a specific Form Submission' do
      do_request

      response = JSON.parse(response_body)
      expect(response.keys).to eq %w[id form question_submissions]
      expect(response['id']). to eq form_submission.id
      expect(status).to eq 200
    end
  end

  post '/api/v1/form_submissions' do
    parameter :form_id, scope: :form_submission
    parameter :question_submissions, scope: :form_submission

    before do
      f = Form.find(form_id)
      @q = f.questions.first
      @q.choices << Choice.create(label: 'yes', maximum_chosen: 3)
      @q.save!
    end

    let(:question_submissions) do
      question_submission_list = FactoryGirl.build_list(:question_submission, 1, question: @q, string: 'yes')
      desired_hash = {}
      question_submission_list.map do |qs|
        value = qs.slice(:question_id, :string, :text, :boolean)
        desired_hash[qs.question_id] = [value]
      end
      desired_hash
    end

    let(:new_form_submission) { FactoryGirl.create(:form_submission) }
    let(:form_id) { new_form_submission.form.id }

    example_request 'Creating a form submission' do
      response = JSON.parse(response_body)
      expect(response.keys).to eq %w[id form question_submissions]
      expect(response['form']['application_id']).to eq new_form_submission.form.application_id
      expect(status).to eq(201)
    end
  end

  post '/api/v1/form_submissions' do
    parameter :form_id, scope: :form_submission
    parameter :question_submissions, scope: :form_submission

    before do
      f = Form.find(form_id)
      @q = f.questions.first
      @q.choices << Choice.create(label: 'yes', maximum_chosen: 1)
      @q.save!
    end

    let(:question_submissions) do
      # format:
      # {
      #   "1": [[{question_id: 1, string: "yes", boolean: true}]],
      #   "2": [
      #           [
      #             {question_id: 2, string: "yes", boolean: true},
      #             {question_id: 2, string: "yes", boolean: true}
      #           ]
      #         ]
      # }
      question_submission_list = FactoryGirl.build_list(:question_submission, 3, question: @q, string: 'yes')
      desired_hash = {}
      question_submission_list.map do |qs|
        value = qs.slice(:question_id, :string, :text, :boolean)
        desired_hash[qs.question_id] << [value] if desired_hash[qs.question_id]
        desired_hash[qs.question_id] = [value] unless desired_hash[qs.question_id]
      end
      desired_hash
    end

    let(:new_form_submission) { FactoryGirl.create(:form_submission) }
    let(:form_id) { new_form_submission.form.id }

    example_request 'Form submission failing' do
      response = JSON.parse(response_body)
      expect(response.keys).to eq ['error']
      expect(response.values).to eq ['Validation failed: Maxchosen This choice is no longer available']
      expect(status).to eq(500)
    end
  end

  delete '/api/v1/form_submissions/:id' do
    example_request 'Deleting a form submission' do
      expect(status).to eq(204)
    end
  end
end

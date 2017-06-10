# frozen_string_literal: true

class FormSubmissionSerializer < ActiveModel::Serializer
  attributes :id, :form, :question_submissions

  def question_submissions
    QuestionSubmission.includes(:question).where(form_submission: object).map do |qs|
      { id: qs.id, value: qs.value, question_type: qs.question.question_type }
    end
  end
end

# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :key, :label, :content, :required,
             :order, :hidden, :question_type, :validate_as,
             :placeholder,
             :question_dependency, :section_id, :choices

  # Not calling question dependency serializer, not sure why
  def question_dependency
    question_dependency_json(object) if object.question_dependency
  end

  private def question_dependency_json(object)
    {
      id: object.question_dependency.id,
      display: object.question_dependency.display,
      question_dependency_choices: object.question_dependency.question_dependency_choices,
      and: object.question_dependency.and
    }
  end

  # FIXME
  # has_one :question_dependency
  # has_many :choices
end

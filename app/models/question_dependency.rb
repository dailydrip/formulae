# frozen_string_literal: true

class QuestionDependency < ApplicationRecord
  include Uuidable
  belongs_to :question
  has_many :question_dependency_choices, dependent: :destroy
  accepts_nested_attributes_for :question_dependency_choices, allow_destroy: true
end

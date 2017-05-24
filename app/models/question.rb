# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :section
  has_many :question_submissions
  has_many :choices, dependent: :destroy
  has_one :question_dependency

  delegate :form, to: :section
end

# frozen_string_literal: true

class FormSerializer < ActiveModel::Serializer
  attributes :id, :application, :completion_content

  has_many :sections
  has_many :questions
end

# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions, &:timestamps
  end
end

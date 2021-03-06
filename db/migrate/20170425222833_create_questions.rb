# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions, id: false do |t|
      t.uuid :id, null: false
      t.string :key
      t.string :label
      t.text :content
      t.integer :order
      t.boolean :hidden
      t.string :question_type
      t.string :validate_as
      t.timestamps
    end
    add_index :questions, :id, unique: true
  end
end

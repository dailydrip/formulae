# frozen_string_literal: true

class CreateChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :choices, id: false do |t|
      t.uuid :id
      t.uuid :question_id
      t.uuid :question_dependency_id
      t.jsonb :metadata, default: '{}'
      t.integer :maximum_chosen
      t.string :label
      t.timestamps
    end
    add_index :choices, :question_id
    add_index :choices, :question_dependency_id
    add_index :choices, :id, unique: true
  end
end

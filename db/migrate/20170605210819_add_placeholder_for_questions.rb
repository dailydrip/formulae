class AddPlaceholderForQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :placeholder, :string
  end
end

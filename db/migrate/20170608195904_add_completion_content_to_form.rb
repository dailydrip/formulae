class AddCompletionContentToForm < ActiveRecord::Migration[5.1]
  def change
    add_column :forms, :completion_content, :text
  end
end

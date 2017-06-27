class AddTokenToApiKeys < ActiveRecord::Migration[5.1]
  def change
    add_column :api_keys, :token, :string
    add_index :api_keys, :token, unique: true
  end
end

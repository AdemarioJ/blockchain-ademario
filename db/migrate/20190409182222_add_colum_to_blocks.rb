class AddColumToBlocks < ActiveRecord::Migration[5.1]
  def change
    add_column :blocks, :transactions_hash, :string
    add_column :blocks, :nonce, :string
    add_column :blocks, :hash, :string
  end
end

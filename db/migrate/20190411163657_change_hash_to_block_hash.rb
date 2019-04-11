class ChangeHashToBlockHash < ActiveRecord::Migration[5.1]
  def change
    rename_column :blocks, :hash, :hash_id
  end
end

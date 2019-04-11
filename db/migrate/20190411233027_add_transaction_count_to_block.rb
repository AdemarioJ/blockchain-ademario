class AddTransactionCountToBlock < ActiveRecord::Migration[5.1]
  def change
    add_column :blocks, :transaction_count, :integer
  end
end

class AddBlockToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :block, foreign_key: true
  end
end

class RemoveColumFromTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :sender, :string
    remove_column :transactions, :recipient, :string
    remove_column :transactions, :amount, :integer
  end
end

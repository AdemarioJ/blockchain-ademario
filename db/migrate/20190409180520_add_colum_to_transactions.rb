class AddColumToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :from, :string
    add_column :transactions, :to, :string
    add_column :transactions, :what, :string
    add_column :transactions, :qty, :decimal
  end
end

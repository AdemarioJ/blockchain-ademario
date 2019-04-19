class CreateBlockchains < ActiveRecord::Migration[5.2]
  def change
    create_table :blockchains do |t|
      t.string :index
      t.string :hash_id
      t.string :previous_hash
      t.string :transactions_hash
      t.integer :transaction_count
      t.integer :nonce

      t.timestamps
    end
  end
end

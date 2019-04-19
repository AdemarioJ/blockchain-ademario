class CreateBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :blocks do |t|
      t.string :index
      t.string :hash_id
      t.integer :amount_transaction

      t.timestamps
    end
  end
end

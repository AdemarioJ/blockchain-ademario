class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :from
      t.string :to
      t.string :what
      t.string :qty
      t.references :block, foreign_key: true

      t.timestamps
    end
  end
end

class CreateBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :blocks do |t|
      t.string :index
      t.string :timestamp
      t.string :proof
      t.string :previous_hash

      t.timestamps
    end
  end
end

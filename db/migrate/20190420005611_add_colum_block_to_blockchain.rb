class AddColumBlockToBlockchain < ActiveRecord::Migration[5.2]
  def change
    add_reference :blockchains, :block, foreign_key: true
  end
end

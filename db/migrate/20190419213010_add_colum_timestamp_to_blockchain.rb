class AddColumTimestampToBlockchain < ActiveRecord::Migration[5.2]
  def change
    add_column :blockchains, :timestamp, :datetime
  end
end

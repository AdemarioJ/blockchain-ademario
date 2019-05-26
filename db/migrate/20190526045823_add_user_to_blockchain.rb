class AddUserToBlockchain < ActiveRecord::Migration[5.2]
  def change
    add_reference :blockchains, :user, foreign_key: true
  end
end

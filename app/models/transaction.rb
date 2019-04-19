class Transaction < ApplicationRecord
  
  require "merkletree"
  
  belongs_to :block

  def self.generate_transactions_hash(transactions)
    transactions.empty? ? '0' : MerkleTree.compute_root_for( transactions )
  end
end

class Transaction < ApplicationRecord
  
  require "merkletree"
  
  belongs_to :block

  def self.generate_transactions_hash(transactions)
    transactions.empty? ? '0' : MerkleTree.compute_root_for( transactions )
  end

  def self.generate(block, transactions)
    transactions.each do |transaction|
      block_transaction = Transaction.new
      block_transaction.block_id = block.id
      block_transaction.pais = "Brasil"
      block_transaction.uf = transaction[:uf]
      block_transaction.cidade = transaction[:cidade]
      block_transaction.bairro = transaction[:bairro]
      block_transaction.rua = transaction[:rua]
      block_transaction.numero = transaction[:numero]
      block_transaction.cep = transaction[:cep]
      block_transaction.endereco = transaction[:endereco]
      block_transaction.fabricacao = transaction[:fabricacao]
      block_transaction.validade = transaction[:validade]
      block_transaction.tipo = transaction[:tipo]
      block_transaction.empresa = transaction[:empresa]
      block_transaction.data = I18n.l Date.today
      block_transaction.horario = I18n.l Time.now, :format => :horario

      block_transaction.save
    end
  end

  def self.generate_genesis(block)
      block_transaction = Transaction.new
      block_transaction.block_id = block.id
      block_transaction.pais = "Brasil"
      block_transaction.data = I18n.l Date.today
      block_transaction.horario = I18n.l Time.now, :format => :horario

      block_transaction.save
  end

end

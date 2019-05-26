class Blockchain < ApplicationRecord
  
  belongs_to :user

  #Calcula a Hash do bloco
  def calc_hash_with_nonce( block, transactions , transactions_count, previous_hash, nonce=0 )
    sha = Digest::SHA256.new
    
    if previous_hash.nil?
      previous_hash = 0
    else
      previous_hash = previous_hash.hash_id
    end

    sha.update( nonce.to_s +
                block.index.to_s +
                block.created_at.to_s +
                transactions_count.to_s +
                block.transactions.to_s +
                previous_hash.to_s )
    sha.hexdigest
  end

  # Mineração
  def compute_proof_of_work( block, transactions, transactions_count, previous_hash, difficulty="0000" )
    nonce = 0
    loop do
        hash = calc_hash_with_nonce( block, transactions, transactions_count, previous_hash, nonce )
        if hash.start_with?( difficulty )
          puts"Bloco válidado!"
          return [true, nonce, hash]    ## Bingo! prova de trabalho se hash começa com zeros à esquerda (00)
        else
          nonce += 1             ## continue tentando (e tentando e tentando)
        end
    end
  end

  # Válidação do bloco
  def self.validation_block(block, current_user)
    blockchain = Blockchain.new 
    previous_hash = Blockchain.last
    transactions = Transaction.where("block_id = ?", block.id)
    transactions_count = transactions.count
    blockchain = blockchain.compute_proof_of_work(block, transactions, transactions_count, previous_hash) #Gera uma Hash de identificação do bloco
    if blockchain[0]
      #Inserindo na blockchain
      new_block_in_blockchain = Blockchain.set_block_in_blockchain(block, transactions, transactions_count, blockchain, current_user)
      return new_block_in_blockchain
    else
      return new_block_in_blockchain
    end
  end

  # Inserindo novo bloco na blockchain
  def self.set_block_in_blockchain(block, transactions, transaction_count, blockchain, current_user)
    create_blockchain = Blockchain.new
    create_blockchain.index = Block.last.nil? ? '0' : (Block.last.index.to_i + 1).to_s
    create_blockchain.hash_id = blockchain[2]
    create_blockchain.previous_hash = Blockchain.last.nil? ? '0' : Blockchain.last.hash_id
    create_blockchain.transactions_hash = Transaction.generate_transactions_hash(transactions)
    create_blockchain.transaction_count = transaction_count
    create_blockchain.nonce = blockchain[1]
    create_blockchain.timestamp = block.created_at
    create_blockchain.block_id = block.id
    create_blockchain.user_id = current_user.id

    if create_blockchain.save!
      return [true, create_blockchain]
    else
      return [false]
    end
  end


end

class Blockchain < ApplicationRecord
  
  belongs_to :user
  belongs_to :block

  # Válidação do bloco
  def self.validation_block(block, current_user)
    transactions = Transaction.where("block_id = ?", block.id)
    transactions_count = transactions.count
    last_block = Blockchain.where("user_id = ?", current_user.id).last
    blockchain = Blockchain.new 
    blockchain.previous_hash = last_block.nil? ? '0000000000000000000000000000000000000000000000000000000000000000' : last_block.hash_id
    proof_of_work = blockchain.compute_proof_of_work(block, transactions, transactions_count, blockchain) #Gera uma Hash de identificação do bloco

    #Verifica se o hash_id foi validado, se sim insira na blockchain
    if proof_of_work[0]
<<<<<<< HEAD
      #Inserindo na blockchain
      new_block_in_blockchain = Blockchain.set_block_in_blockchain(block, transactions, transactions_count, blockchain, current_user, last_block)
=======
      blockchain.nonce = proof_of_work[1]
      blockchain.hash_id = proof_of_work[2]
      new_block_in_blockchain = Blockchain.set_block_in_blockchain(block, transactions, transactions_count, blockchain, current_user)
>>>>>>> 242b1feed98a7334e2a80df0201eea8f7be34b50
      return new_block_in_blockchain
    else
      return false
    end
  end

  # Inserindo novo bloco na blockchain
  def self.set_block_in_blockchain(block, transactions, transaction_count, blockchain, current_user, last_block)
    create_blockchain = Blockchain.new
    create_blockchain.index = Block.last.id == 1 ? '0' : (Block.last.index.to_i + 1).to_s
    create_blockchain.hash_id = blockchain.hash_id
    create_blockchain.previous_hash = blockchain.previous_hash
    create_blockchain.transactions_hash = Transaction.generate_transactions_hash(transactions)
    create_blockchain.transaction_count = transaction_count
    create_blockchain.nonce = blockchain.nonce
    create_blockchain.timestamp = block.created_at
    create_blockchain.block_id = block.id
    create_blockchain.user_id = current_user.id

    if create_blockchain.index == '0'   
      create_blockchain.save
      puts "__ Bloco Gênese gerado __"
      return [true, create_blockchain]
    elsif (Block.last.index.to_i + 1 != create_blockchain.index.to_i)
      puts 'invalid index'
      return [false]
    elsif (last_block.hash_id != create_blockchain.previous_hash)
      puts 'invalid previoushash'
      return [false]
    elsif (blockchain.hash_id != create_blockchain.hash_id)
      puts 'invalid hash: ' + blockchain.hash_id + ' ' + create_blockchain.hash_id
      return [false]
    end

    create_blockchain.save
    return [true, create_blockchain]

  end

  def self.validation_save_block(block, current_user)
    if block.nil?
      return false
    else
      result = validation_block( block, current_user )
      if result[0]
        return true       
      else   
        return false       
      end 
    end
  end
  
  # Mineração
  def compute_proof_of_work( block, transactions, transactions_count, blockchain, difficulty = "0000" )
    nonce = 0
    loop do
        hash = calc_hash_with_nonce( block, transactions, transactions_count, blockchain, nonce )
        if hash.start_with?( difficulty )
          puts"Bloco válidado!"
          return [true, nonce, hash]    ## Bingo! prova de trabalho se hash começa com zeros à esquerda (00)
        else
          nonce += 1             ## continue tentando (e tentando e tentando)
        end
    end
  end

  #Calcula a Hash do bloco
  def calc_hash_with_nonce( block, transactions , transactions_count, blockchain, nonce = 0 )
    sha = Digest::SHA256.new
    
    unless blockchain.previous_hash.present?
      blockchain.previous_hash = 0
    end
    previous_hash = blockchain.previous_hash

    sha.update( nonce.to_s +
                block.index.to_s +
                block.created_at.to_s +
                transactions_count.to_s +
                block.transactions.to_s +
                previous_hash.to_s )
    sha.hexdigest
  end


end

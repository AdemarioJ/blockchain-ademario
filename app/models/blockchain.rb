class Blockchain < ApplicationRecord
      
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

  
  def generate_block_genesis(block)
    puts "Genesis"
  end


end

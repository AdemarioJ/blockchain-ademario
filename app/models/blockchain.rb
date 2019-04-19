class Blockchain < ApplicationRecord
      
  #Calcula a Hash do bloco
  def calc_hash_with_nonce( block, nonce=0 )
    sha = Digest::SHA256.new
    sha.update( nonce.to_s +
                block.index.to_s +
                block.timestamp.to_s +
                block.transaction_count.to_s +
                block.transactions.to_s +
                block.previous_hash.to_s )
    sha.hexdigest
  end

    # Mineração
  def compute_proof_of_work( hash_id, difficulty="0000" )
    nonce = 0
    loop do
        hash = hash_id
        if hash.start_with?( difficulty )
        return [nonce,hash]    ## Bingo! prova de trabalho se hash começa com zeros à esquerda (00)
        else
        nonce += 1             ## continue tentando (e tentando e tentando)
        end
    end
  end


end

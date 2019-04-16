class Block < ApplicationRecord

    require "merkletree"
    require "digest"    # para função de resumo de soma de verificação de hash SHA256

    has_many :transactions
    
    # Mineração
    def compute_hash_with_proof_of_work( block, difficulty="0000" )
        nonce = 0
        loop do
          hash = calc_hash_with_nonce( block, nonce )
          if hash.start_with?( difficulty )
            return [nonce,hash]    ## Bingo! prova de trabalho se hash começa com zeros à esquerda (00)
          else
            nonce += 1             ## continue tentando (e tentando e tentando)
          end
        end
    end
    
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

end

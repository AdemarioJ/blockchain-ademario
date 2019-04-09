class Block < ApplicationRecord

    require "merkletree"
    require "digest"    # para função de resumo de soma de verificação de hash SHA256

    has_many :transactions
    
    def compute_hash_with_proof_of_work( difficulty="00" )
        nonce = 0
        loop do
          hash = calc_hash_with_nonce( nonce )
          if hash.start_with?( difficulty )
            return [nonce,hash]    ## Bingo! prova de trabalho se hash começa com zeros à esquerda (00)
          else
            nonce += 1             ## continue tentando (e tentando e tentando)
          end
        end
    end
    
    def calc_hash_with_nonce( nonce=0 )
    sha = Digest::SHA256.new
    sha.update( nonce.to_s +
                @index.to_s +
                @timestamp.to_s +
                @transactions_count.to_s +
                @transactions.to_s +
                @previous_hash )
    sha.hexdigest
    end

end

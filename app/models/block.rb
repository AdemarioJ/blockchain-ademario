class Block < ApplicationRecord

    require "merkletree"
    require "digest"    # para função de resumo de soma de verificação de hash SHA256

    has_many :transactions

    def initialize(index, transactions, previous_hash, timestamp: nil, nonce: nil)

        @index         = index
        @timestamp     = Time.now.utc
        @transactions  = transactions
        @transactions_count = transactions.size
        @previous_hash = previous_hash
    
        ## todo: adicionar verificação de matriz vazia para merkletree.compute por quê? Por que não?
        @transactions_hash  = transactions.empty? ? '0' : MerkleTree.compute_root_for( transactions )
    
        if nonce     ## restore pre-computed/mined block (from disk/cache/db/etc.)
          ## todo: check timestamp MUST NOT be nil
          @nonce = nonce
          @hash  = calc_hash
       else   ## new block  (mine! e.g. find nonce - "lucky" number used once)
          @nonce, @hash = compute_hash_with_proof_of_work
       end
    end
    
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

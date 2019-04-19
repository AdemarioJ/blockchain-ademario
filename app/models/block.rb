class Block < ApplicationRecord

    require "merkletree"
    require "digest"    # para função de resumo de soma de verificação de hash SHA256

    has_many :transactions

    def first( args )    # Cria o genesis 
        ##  note: allow/support splat-* for now for convenience (auto-wraps args into array)
        if args.size == 1 && args[0].is_a?( Array )
          transactions = args[0]   ## "unwrap" array in array
        else
          transactions = args      ## use "auto-wrapped" splat array
        end
        ## uses index zero (0) and arbitrary previous_hash ('0')
        ## note: pass along (optional) custom timestamp (e.g. used for 1637 etc.)
  
        new_block( 0, transactions )
  
    end
    
    def next( previous, args )
        ## note: allow/support splat-* for now for convenience (auto-wraps args into array)
        if args.size == 1 && args[0].is_a?( Array )
          transactions = args[0]   ## "unwrap" array in array
        else
          transactions = args      ## use "auto-wrapped" splat array
        end
  
        new_block( previous.index.to_i+1, transactions )
  
    end

    def new_block(index, transactions, nonce: nil)
  
        block = Block.new
        block.index = index.to_s
        block.amount_transaction = 20        
        
        block.hash_id = block.calc_hash(block)
    
        if block.save!
          puts"Novo bloco adicionado!"
        end
    
        transactions.each do |transaction|
          from = transaction[:from]
          to = transaction[:to]
          what = transaction[:what]
          qty = transaction[:qty]
    
          transaction = Transaction.new
          transaction.from = from
          transaction.to = to
          transaction.what = what
          transaction.qty = qty
          transaction.block_id = block.id
    
          if transaction.save!
            puts"Transação salva"
          end
        end
        
      end

    
    # Mineração
    #def compute_hash_with_proof_of_work( block, difficulty="0000" )
     #   nonce = 0
   #      loop do
      #      hash = calc_hash_with_nonce( block, nonce )
    #         if hash.start_with?( difficulty )
     #        return [nonce,hash]    ## Bingo! prova de trabalho se hash começa com zeros à esquerda (00)
   #          else
    #         nonce += 1             ## continue tentando (e tentando e tentando)
    #         end
  #       end
   #  end

    #Calcula a Hash do bloco
  def calc_hash( block, nonce=0 )
      sha = Digest::SHA256.new
      timestamps = Time.now.utc
      sha.update( nonce.to_s +
                  block.index.to_s +
                  block.created_at.to_s )
      sha.hexdigest
  end
        

end

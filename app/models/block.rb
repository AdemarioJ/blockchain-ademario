class Block < ApplicationRecord

    require "digest"    # para função de resumo de soma de verificação de hash SHA256

    has_many :transactions
    has_many  :blockchains

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
    
    def next( previous, args, group = nil )
        ## note: allow/support splat-* for now for convenience (auto-wraps args into array)
        if args.size == 1 && args[0].is_a?( Array )
          transactions = args[0]   ## "unwrap" array in array
        else
          transactions = args      ## use "auto-wrapped" splat array
        end

        if group.nil?
          new_block( previous.index.to_i+1, transactions )

        else
          new_block( previous.index.to_i+1, transactions, group )

        end
  
    end

    def new_block( index, transactions, group = nil )
      
        block = Block.new
        block.index = index.to_s
        block.amount_transaction = 20        
        block.hash_id = block.calc_hash(block)

        if group.nil?
          block.group = Block.last.nil? ? '0' : (Block.last.group.to_i + 1).to_s

        else
          block.group = group

        end
        
        if block.save!
          puts"Novo bloco adicionado!"
        end
    
        transactions.each do |transaction|
          block_transaction = Transaction.new
          block_transaction.from =  transaction[:from]
          block_transaction.to = transaction[:to]
          block_transaction.what = transaction[:what]
          block_transaction.qty = transaction[:qty]
          block_transaction.block_id = block.id
          block_transaction.pais = transaction[:pais]
          block_transaction.uf = transaction[:uf]
          block_transaction.cidade = transaction[:cidade]
          block_transaction.bairro = transaction[:bairro]
          block_transaction.rua = transaction[:rua]
          block_transaction.numero = transaction[:numero]
          block_transaction.cep = transaction[:cep]
          block_transaction.endereco = transaction[:endereco]
          block_transaction.data = I18n.l Date.today
          block_transaction.horario = I18n.l Time.now, :format => :horario

          if block_transaction.save!
            puts"Transação salva"
          end
        end

        return block
        
      end

  def calc_hash( block, nonce=0 )
      sha = Digest::SHA256.new
      timestamps = Time.now.utc
      sha.update( nonce.to_s +
                  block.index.to_s +
                  block.created_at.to_s )
      sha.hexdigest
  end
        

end

class Block < ApplicationRecord
  attr_accessor :new_transactions

  require "digest"    # para função de resumo de soma de verificação de hash SHA256

  has_many :transactions
  has_many  :blockchains

  after_save :set_transactions

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
    block.new_transactions = transactions

    if block.save
      puts"Novo bloco adicionado!"
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

  def set_transactions
    transaction = Transaction.generate(self, new_transactions)
  end
        
end
class Transaction < ApplicationRecord

  belongs_to :block

  def first( args )    # Cria o genesis 
      ##  note: allow/support splat-* for now for convenience (auto-wraps args into array)
      if args.size == 1 && args[0].is_a?( Array )
        transactions = args[0]   ## "unwrap" array in array
      else
        transactions = args      ## use "auto-wrapped" splat array
      end
      ## uses index zero (0) and arbitrary previous_hash ('0')
      ##  note: pass along (optional) custom timestamp (e.g. used for 1637 etc.)

      new_block( 0, transactions, '0', timestamp: Time.now.utc )

  end
  
  def next( previous, args )
      ## note: allow/support splat-* for now for convenience (auto-wraps args into array)
      if args.size == 1 && args[0].is_a?( Array )
        transactions = args[0]   ## "unwrap" array in array
      else
        transactions = args      ## use "auto-wrapped" splat array
      end
      
      new_block( Block.last.index.to_i+1, transactions,  Block.last.hash, timestamp: Time.now.utc )

  end

  private

  def new_block(index, transactions, previous_hash, timestamp: nil, nonce: nil)
  
    block = Block.new
    block.index = index.to_s
    block.timestamp = timestamp
    block.transactions_count = transactions.size
    block.previous_hash = previous_hash
    
    block.transactions_hash = transactions.empty? ? '0' : MerkleTree.compute_root_for( transactions )

    if nonce     ## restore pre-computed/mined block (from disk/cache/db/etc.)
      ## todo: check timestamp MUST NOT be nil
      puts "Nonce 1 = #{nonce}"
      block.nonce = nonce
      block.hash = calc_hash
    else   ## new block  (mine! e.g. find nonce - "lucky" number used once)
      puts "Nonce 2 = #{nonce}"
      block.nonce, block.hash = block.compute_hash_with_proof_of_work
    end

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


end

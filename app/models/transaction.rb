class Transaction < ApplicationRecord

    def self.first( *args, **opts )    # create genesis (big bang! first) block
        ##  note: allow/support splat-* for now for convenience (auto-wraps args into array)
        if args.size == 1 && args[0].is_a?( Array )
          transactions = args[0]   ## "unwrap" array in array
        else
          transactions = args      ## use "auto-wrapped" splat array
        end
        ## uses index zero (0) and arbitrary previous_hash ('0')
        ##  note: pass along (optional) custom timestamp (e.g. used for 1637 etc.)
        Block.new( 0, transactions, '0', timestamp: opts[:timestamp] )
    end
    
    def self.next( previous, *args, **opts )
        ## note: allow/support splat-* for now for convenience (auto-wraps args into array)
        if args.size == 1 && args[0].is_a?( Array )
          transactions = args[0]   ## "unwrap" array in array
        else
          transactions = args      ## use "auto-wrapped" splat array
        end
        Block.new( previous.index+1, transactions, previous.hash, timestamp: opts[:timestamp] )
    end

end

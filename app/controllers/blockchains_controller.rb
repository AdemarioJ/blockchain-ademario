class BlockchainsController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => [:validation_block]

    def index
      
    end

    #Validação do bloco
    def validation_block

      if params[:hash_id].present?
        blockchain = Blockchain.new 
        block = Block.find_by(hash_id: params[:hash_id])
        previous_hash = Blockchain.last
        transactions = Transaction.where("block_id = ?", block.id)
        transactions_count = transactions.count
        blockchain = blockchain.compute_proof_of_work(block, transactions, transactions_count, previous_hash) #Gera uma Hash de identificação do bloco

        if blockchain[0]
          #Inserindo na blockchain
          new_block_in_blockchain = set_block_in_blockchain(block, transactions, transactions_count, blockchain)
          unless new_block_in_blockchain[0]
            response = { status:false, message: "Bloco não foi válidado!"}
            return json_response(response)  
            
          end
          response = { status:blockchain[0], nonce: blockchain[1], hash_id:blockchain[2], blockchain: new_block_in_blockchain[1]  }
          json_response(response)
        else
          response = { status:false, message: "Bloco não foi válidado!"}
          json_response(response)       
         end
      else
        response = { status:false, message: "Bloco não foi válidado!"}
        json_response(response)  
      end
    end
  
    def edit
      @blockchain = Blockchain.find(params[:id])
    end
    
    # GET /blockchain/new
    def new
      @blockchain = Blockchain.new
    end
  
    def create
      @blockchain = Blockchain.new(blockchain_params)
    end
    
    def show
      @blockchain = Blockchain.all 
    end
    
    private

      def set_block_in_blockchain(block, transactions, transaction_count, blockchain)
        create_blockchain = Blockchain.new
        create_blockchain.index = Blockchain.last.nil? ? '0' : (Blockchain.last.index.to_i + 1).to_s
        create_blockchain.hash_id = blockchain[2]
        create_blockchain.previous_hash = Blockchain.last.nil? ? '0' : Blockchain.last.hash_id
        create_blockchain.transactions_hash = Transaction.generate_transactions_hash(transactions)
        create_blockchain.transaction_count = transaction_count
        create_blockchain.nonce = blockchain[1]
        create_blockchain.timestamp = block.created_at

        if create_blockchain.save!
          return [true, create_blockchain]
        else
          return [false]
        end
      end
  
      def set_blockchain
        @blockchain = Blockchain.find(params[:id])
      end
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def blockchain_params
        params.require(:blockchain).permit(:from, :to, :what, :qty, :block_id)
      end

      def json_response(message, code = :ok)
        render json: message, status: code
      end

end

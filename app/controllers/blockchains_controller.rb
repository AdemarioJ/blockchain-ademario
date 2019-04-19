class BlockchainsController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => [:validation_block]

    def index
      
    end

    def validation_block

      if params[:hash_id].present?
        blockchain = Blockchain.new 
        block = Block.find_by(hash_id: params[:hash_id])
        previous_hash = Blockchain.last
        transactions = Transaction.where("block_id = ?", block.id)
        blockchain = blockchain.compute_proof_of_work(block, transactions, transactions.count, previous_hash)

        if blockchain[0]
          response = { status:blockchain[0], nonce: blockchain[1], hash_id:blockchain[2] }
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

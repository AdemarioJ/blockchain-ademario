class TransactionsController < ApplicationController
    require 'rqrcode'
    require 'io/console'
  
    def index
      
    end
  
    def edit
      @blockchain = Block.find(params[:id])
    end
    
    # GET /blockchain/new
    def new
      @blockchain = Transaction.new
    end
  
    def create
      @block = Block.new
      fist_transaction = Block.all
  
      if fist_transaction.count == 0
        @block = @block.first( [transaction_params] )
        new_block_in_blockchain = Blockchain.validation_block( @block )
        
        verification_result(new_block_in_blockchain)

      else
        @block = @block.next( Block.last,[transaction_params] )
        new_block_in_blockchain = Blockchain.validation_block( @block )

        verification_result(new_block_in_blockchain)

      end
  
    end
    
    def show
      @blockchain = Block.all 
    end
    
    private

      def json_response(message, code = :ok)
        render json: message, status: code
      end
  
      def set_transaction
        @blockchain = Transaction.find(params[:id])
      end
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def transaction_params
        params.require(:transaction).permit(:from, :to, :what, :qty, :block_id)
      end

      def verification_result(blockchain)
        unless blockchain[0]
          response = { status:false, message: "Bloco não foi válidado!"}
          return json_response(response)  
        end

        response = { status:blockchain[0], blockchain: blockchain[1] }
        json_response(response)
      end
end

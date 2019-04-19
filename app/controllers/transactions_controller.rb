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
        @block.first([transaction_params])
      else
        @block.next( Block.last,[transaction_params])
      end
  
    end
    
    def show
      @blockchain = Block.all 
    end
    
    private
  
      def set_transaction
        @blockchain = Transaction.find(params[:id])
      end
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def transaction_params
        params.require(:transaction).permit(:from, :to, :what, :qty, :block_id)
      end
end

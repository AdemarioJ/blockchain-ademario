class BlockchainsController < ApplicationController
    def index
      
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

end

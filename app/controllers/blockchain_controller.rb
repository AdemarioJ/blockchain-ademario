class BlockchainController < ApplicationController
  
  def blockchain
    blockchain = Transaction.new
  end

  def index
    
  end

  def edit
    @blockchain = Transaction.find(params[:id])
  end
  
  # GET /blockchain/new
  def new
    @blockchain = Transaction.new
  end

  def create
    @blockchain = Transaction.new(blockchain_params)
    fist_transaction = Transaction.all

    if fist_transaction.count == 0
      @blockchain.first([blockchain_params])
    else
      @blockchain.next( Block.last.index,[blockchain_params])
    end

  end

  def show
    @blockchain = Block.all 
  end
  
  private

    def set_blockchain
      @blockchain = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blockchain_params
      params.require(:transaction).permit(:from, :to, :what, :qty, :block_id)
      #params.require(:blockchain).permit(:from, :to, :what, :qty)
    end
  
end

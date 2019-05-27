class TransactionsController < ApplicationController
    before_action :authenticate_user!

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
      new_block_in_blockchain = nil

      if fist_transaction.count == 0
        @block = @block.first( [transaction_params] )
        new_block_in_blockchain = Blockchain.validation_block( @block, current_user )
        new_block_in_blockchain =  verification_result(new_block_in_blockchain)
      else
        @block = @block.next( Block.last, [transaction_params] )
        new_block_in_blockchain = Blockchain.validation_block( @block, current_user )
        new_block_in_blockchain =  verification_result(new_block_in_blockchain)
      end

      respond_to do |format|
        if new_block_in_blockchain
          format.html { redirect_to "/blockchain" , notice: 'Queijo cadastrado com sucesso.' }
        else
          format.html { render :new, notice: 'Erro ao validar cadastro!'}
        end
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
        params.require(:transaction).permit(:from, :to, :what, :qty, :block_id, :latitude, :longitude, :pais, :uf, :cidade, :bairro, :rua, :numero, :cep, :data, :horario, :endereco, :fabricacao, :validade, :tipo, :empresa) 
      end

      def verification_result(blockchain)
        if blockchain[0]
          return true       

        else   
          return false       
        end
      end
end

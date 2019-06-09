class TransactionsController < ApplicationController
    before_action :authenticate_user!

    require 'rqrcode'
    require 'io/console'
    require 'uri'
    require 'net/http'
  
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
        @block = @block.first(  )
        new_block_in_blockchain = Blockchain.validation_save_block(@block, current_user)
      
        @block = @block.next( Block.last, [transaction_params] )
        new_block_in_blockchain = Blockchain.validation_save_block(@block, current_user)
      else
        @block = @block.next( Block.last, [transaction_params] )
        new_block_in_blockchain = Blockchain.validation_save_block(@block, current_user)
      end

      respond_to do |format|
        if new_block_in_blockchain
          network_blockchain(Blockchain.last.hash_id)
          format.html { redirect_to "/blockchain", notice: 'Queijo cadastrado com sucesso.' }
        else
          format.html { redirect_to "/blockchain", alert: 'Erro ao validar cadastro!'}
        end
      end
  
    end
    
    def show
      @blockchain = Block.all 
    end

    def set_block_genesis
      transaction = Transaction.new
      transaction.from = nil
      transaction.to = nil
      transaction.what = nil
      transaction.qty = nil
      transaction.block_id = nil
      transaction.latitude = nil
      transaction.longitude = nil
      transaction.pais = nil
      transaction.uf = nil
      transaction.cidade = nil
      transaction.bairro = nil
      transaction.rua = nil
      transaction.numero = nil
      transaction.cep = nil
      transaction.data = nil
      transaction.horario = nil
      transaction.endereco = nil
      transaction.fabricacao = nil
      transaction.validade = nil
      transaction.tipo = nil
      transaction.empresa =nil
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


      def network_blockchain(hash_id)
        url = URI("http://localhost:3001/mineBlock")
        
        http = Net::HTTP.new(url.host, url.port)

        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = 'application/json'
        request.body = {hash_id: hash_id}.to_json

        response = http.request(request)
        
        if response.kind_of? Net::HTTPSuccess
          puts"Bloco enviado para a rede com sucesso."
        end

      end
end


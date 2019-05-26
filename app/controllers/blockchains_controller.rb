class BlockchainsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, :only => [:update_informations, :get_transactions_block, :show]

  def index
    @blockchain = Block.joins(:blockchains).order('block_id DESC').group(:group)
    @blockchain = @blockchain.paginate(:page => params[:page], :per_page => 6);
  end

  #Validação do bloco
  def update_informations

    informations = params["informations"] 
    error_msg = validation_informations(informations)

    if error_msg.length == 0
        blocks = Blockchain.find_by("hash_id = ?", informations["hash_id"])
        groups = Block.joins(:blockchains).where("blocks.id = ?", blocks.block_id )
        blockchain = Blockchain.new
        @block = Block.new
        @block = @block.next( Block.last, [informations["transaction"]], groups[0].group )
        new_block_in_blockchain = Blockchain.validation_block( @block )
        verification_result(new_block_in_blockchain)

    else
      json_response(error_msg, :unprocessable_entity)
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
  
  def get_transactions_block
    error_msg = validation_hash(params["hash_id"] )

    if error_msg.length == 0

        transactions = transactions_blockchain(params["hash_id"])

        if transactions == false
          response = { message: "Informações inválidas!", code: :not_found}
          return json_response(response) 
        else
          json_response(transactions, :ok)

        end
    
    else
      json_response(error_msg, :unprocessable_entity)
    end
  end

  private

    def set_blockchain
      @blockchain = Blockchain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blockchain_params
      params.require(:blockchain).permit(:from, :to, :what, :qty, :block_id, :latitude, :longitude, :pais, :uf, :cidade, :bairro, :rua, :cep, :numero, :data, :horario, :endereco)
    end

    def validation_informations(parameters)
    
      #Validando as informações
      error_msg = ""
      error_msg += "Informe o hash_id" unless parameters["hash_id"].present?
      return error_msg

    end

    def validation_hash(hash)
    
      #Validando as informações
      error_msg = ""
      error_msg += "Informe o hash_id" unless hash.present?

      return error_msg

    end

    def json_response(message, code = :ok)
      render json: message, status: code
    end

    def verification_result(blockchain)
      unless blockchain[0]
        response = { status:false, message: "Bloco não foi válidado!"}
        return json_response(response)  
      end

      response = { status:blockchain[0], blockchain: jsonBlockchain(blockchain[1]) }
      json_response(response)
    end

    def transactions_blockchain(hash)

      groups = Blockchain.where("hash_id = ?", hash )

      unless groups.present?
        return false
      end

      block = Block.all.where("blocks.id = ?", groups[0].block_id)
      blocks = Block.all.where("blocks.group = ?", block[0].group)

      transactions = []

      blocks.each do |block|
        transaction = Transaction.where("block_id = ?", block.id)
        transactions << transaction[0]
      end

      return transactions
    end

    def jsonBlockchain(block)
        block = {
          "id": block.id,
          "index": block.index,
          "hash_id": block.hash_id,
          "previous_hash": block.previous_hash,
          "transactions_hash": block.transactions_hash,
          "transaction_count": block.transaction_count,
          "nonce": block.nonce,
          "created_at": block.created_at,
          "updated_at": block.updated_at,
          "timestamp": block.timestamp,
          "block_id": block.block_id
        }
      
    end

end

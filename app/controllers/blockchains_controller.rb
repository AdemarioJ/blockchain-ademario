class BlockchainsController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => [:update_informations, :get_transactions_block]

    def index
      
    end

    #Validação do bloco
    def update_informations

      informations = params["informations"] 
      error_msg = validation_informations(informations)

      if error_msg.length == 0

          groups = Block.joins(:blockchains).where("blocks.hash_id = ?", informations["hash_id"] )
          #blocks = Block.all.where("blocks.group = ?", groups[0].group)
          #transactions = []

          #blocks.each do |block|
            #transaction = Transaction.where("block_id = ?", block.id)
            #transactions << transaction[0]
          #end
          
          blockchain = Blockchain.new
          @block = Block.new
          @block = @block.next( Block.last,[informations["transaction"]], groups[0].group )
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

          groups = Block.joins(:blockchains).where("blocks.hash_id = ?", params["hash_id"] )
          blocks = Block.all.where("blocks.group = ?", groups[0].group)
          transactions = []

          blocks.each do |block|
            transaction = Transaction.where("block_id = ?", block.id)
            transactions << transaction[0]
          end

          json_response(transactions, :ok)
      
      else
        json_response(error_msg, :unprocessable_entity)
      end
    end

    private

      def set_block_in_blockchain(block, transactions, transaction_count, blockchain)
        create_blockchain = Blockchain.new
        create_blockchain.index = Block.last.nil? ? '0' : (Block.last.index.to_i + 1).to_s
        create_blockchain.hash_id = blockchain[2]
        create_blockchain.previous_hash = Blockchain.last.nil? ? '0' : Blockchain.last.hash_id
        create_blockchain.transactions_hash = Transaction.generate_transactions_hash(transactions)
        create_blockchain.transaction_count = transaction_count
        create_blockchain.nonce = blockchain[1]
        create_blockchain.timestamp = block.created_at
        create_blockchain.block_id = block.id

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

      def validation_informations(parameters)
      
        #Validando as informações
        error_msg = ""
        error_msg += "Informe o hash_id" unless parameters["hash_id"].present?
        error_msg += "Informe o de quem é o queijo!" unless parameters["transaction"]["from"].present?
        error_msg += "Informe para quem vai o queijo!" unless parameters["transaction"]["to"].present?
        error_msg += "Informe a descrição!" unless parameters["transaction"]["what"].present?
        error_msg += "Informe o valor!" unless parameters["transaction"]["qty"].present?

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

        response = { status:blockchain[0], blockchain: blockchain[1] }
        json_response(response)
      end

end

class BlockchainController < ApplicationController

  require 'rqrcode'
  require 'io/console'

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
      @blockchain.next( Block.last,[blockchain_params])
    end

  end
  
  def QRcode(code)
    # With default options specified explicitly
    qrcode = RQRCode::QRCode.new(code.to_s)
    qrcode.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 240,
      border_modules: 4,
      module_px_size: 6,
      file: "QRcode.png" )


    return @qr = RQRCode::QRCode.new( code.to_s, :size => 4, :level => :h )
  end

  def show
    @blockchain = Block.all 
    
    qrcode = "ADEMÁRIO JOSÉ DA SILVA"
    @qr = QRcode(qrcode)
  end
  
  private

    def set_blockchain
      @blockchain = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blockchain_params
      params.require(:transaction).permit(:from, :to, :what, :qty, :block_id)
    end
  
end

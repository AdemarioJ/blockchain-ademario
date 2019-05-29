module BlockchainsHelper
    require 'rqrcode'
    require 'rqrcode_png'

    def qrcode(code)
        # With default options specified explicitly
        #Salva a imagem no projeto
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

        #Cria a o QRcode
        @qr = RQRCode::QRCode.new(code.to_s).to_img.resize(200, 200).to_data_url
    end

    def mini_qrcode(code)
      # With default options specified explicitly
      #Salva a imagem no projeto
      qrcode = RQRCode::QRCode.new(code.to_s)
      qrcode.as_png(
        resize_gte_to: false,
        resize_exactly_to: false,
        fill: 'white',
        color: 'black',
        size: 150,
        border_modules: 4,
        module_px_size: 6,
        file: "QRcode.png" )

      #Cria a o QRcode
      @qr = RQRCode::QRCode.new(code.to_s).to_img.resize(80, 80).to_data_url
  end

    def transactions_web(hash)
      
      groups = Blockchain.where("hash_id = ?", hash )
      block = Block.all.where("blocks.id = ?", groups[0].block_id)
      blocks = Block.all.where("blocks.group_id = ?", block[0].group_id)

      transactions = []

      blocks.each do |block|
        transaction = Transaction.where("block_id = ?", block.id)
        transactions << transaction[0]
      end

      return transactions
    end

    def type_cheese(block_id)
      cheese = Transaction.find_by("block_id = ?", block_id)
    end

end

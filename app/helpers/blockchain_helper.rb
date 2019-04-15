module BlockchainHelper
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

end

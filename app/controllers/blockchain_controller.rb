class BlockchainController < ApplicationController
  
  def index
    trasaction = Transaction.new
    b0 = trasaction.first([
      { from: "Ademario", to: "Wagner", what: "A compra de um sapato.", qty: 10 },
      { from: "Wagner",  to: "Marcos",    what: "Jogo de Computador",    qty: 7 }] )
    
    b1 = trasaction.next( b0,
      [{ from: "Flowers", to: "Ruben", what: "Tulip Admiral van Eijck",  qty: 5 },
      { from: "Vicent",  to: "Anne",  what: "Tulip Bloemendaal Sunset", qty: 3 },
      { from: "Anne",    to: "Julia", what: "Tulip Semper Augustus",    qty: 1 },
      { from: "Julia",   to: "Luuk",  what: "Tulip Semper Augustus",    qty: 1 }] )
    
    b2 = trasaction.next( b1,
      [{ from: "Bloom & Blossom", to: "Daisy",   what: "Tulip Admiral of Admirals", qty: 8 },
      { from: "Vincent",         to: "Max",     what: "Tulip Bloemendaal Sunset",  qty: 2 },
      { from: "Anne",            to: "Martijn", what: "Tulip Semper Augustus",     qty: 2 },
      { from: "Ruben",           to: "Julia",   what: "Tulip Admiral van Eijck",   qty: 2 }] )
    
    b3 = trasaction.next( b2,
      [{ from: "Teleflora", to: "Max",     what: "Tulip Red Impression",      qty: 11 },
      { from: "Anne",      to: "Naomi",   what: "Tulip Bloemendaal Sunset",  qty: 1  },
      { from: "Daisy",     to: "Vincent", what: "Tulip Admiral of Admirals", qty: 3  },
      { from: "Julia",     to: "Mina",    what: "Tulip Admiral van Eijck",   qty: 1  }] )
    
  end

  def new
  
  end

  def create
  
  end

  def show
    @blockchain = Blocks.all 
  end
end

class ParsersController < ApplicationController
  def new
    # prepara form per importare un file:
    # - scegliere tipo di import
    # - scegliere file
  end
  
  def create
    # - caricare dal db l'import corrispondente
    # - passare il file al relativo parser
    # - cercare gli account di in e out in base alle regole dell'import
    # - cercare le eventuali transazioni già presenti
    # - preparare la pagina con la conferma delle transazioni
    # - l'immissione vera e propria delle transazioni avviene tramite il transactions_controller
  end
end

class ImportsController < ApplicationController
  def index
    # elenco degli import presenti con possibilità di modifica e creazione nuovo
  end

  def new
    # form per creare nuovo import
  end
  
  def create
    # salva il nuovo import, si possono aggiungere regole solo dopo la creazione
  end
  
  def edit
    # modifica l'import:
    # - scegli nome
    # - scegli parser
    # - aggiungi/togli/modifica regole
  end
  
  def update
    # aggiorna l'import
  end
end

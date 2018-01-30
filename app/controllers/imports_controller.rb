class ImportsController < ApplicationController
  def index
    @imports = Import.all
  end

  def new
    @import = Import.new
    @parsers = Dir[Rails.root.join('lib', 'parser', '*.rb')].map {|parser_file| File.basename(parser_file, ".rb").classify}
  end
  
  def create
    import = Import.new
    import.label = params['label']
    import.parser = params['parser']
    import.save
    redirect_to imports_path
  end
  
  def edit
    @import = Import.find(params['id'])
    @parsers = Dir[Rails.root.join('lib', 'parser', '*.rb')].map {|parser_file| File.basename(parser_file, ".rb").classify}
  end
  
  def update
    import = Import.find(params['id'])
    import.label = params['label']
    import.parser = params['parser']
    import.save
    redirect_to imports_path
  end
end

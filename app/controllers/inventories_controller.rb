class InventoriesController < ApplicationController

  def allowed?(action)
    true
  #    case action
  #      when 'new' || 'create' then current_user_has_role?('crear inventarios')
  #      when 'index' || 'show' then current_user_has_role?('ver inventarios')
  #      when 'edit' || 'update' then current_user_has_role?('modificar inventarios')  
  #      when 'delete' then current_user_has_role?('borrar inventarios')
  #    else false
  end
    
  def new
    @inventory = Inventory.new
  end
    
  def create
    @inventory = Inventory.new(params[:inventory])
    if @inventory.save
      redirect_to(inventories_url, :notice => 'Nuevo inventario creado.')
    else
      render :action => 'new'
    end
  end

  def index
    @inventories = Inventory.select(:all).order(:date)
  end
    
  def show
    @inventory = Inventory.find(params[:id])
  end
  
  def edit
    @inventory = Inventory.find(params[:id])
  end
    
  def update
  end
    
  def destroy
  end
    
  def existences
  end
    
  def existences_make_spreadsheet
    @book = Spreadsheet::Workbook.new
    @sheet = @book.create_worksheet :name => "Existencias"
    @sheet[0,0] = 'Homy Hogar'
    @sheet[1,0] = "Existencias a #{params_to_datetime(params[:date]).strftime("%d/%m/%Y - %H:%M.%S")}"
    @row = 3
      
    @suppliers = Bussiness.where(:supplier => true).order(:name)
    @suppliers.each do |s|
      @sheet[@row,0] = s.name
      @row = @row + 1
      @products = Product.where(:supplier_id => s.id).order(:code)
      @products.each do |p|
        @sheet[@row,0] = p.code
        @sheet[@row,1] = p.product_category.name
        @sheet[@row,2] = p.description
        @sheet[@row,3] = p.quantity
        @row = @row + 1
      end
      @row = @row + 1
    end
            
    @file_name = "data/existences/existencias-#{params_to_datetime(params[:date]).strftime("%Y%m%d-%H%M%S")}.xls"
    @book.write @file_name
    send_file @file_name, :type => 'application/xls'
  end
    
end

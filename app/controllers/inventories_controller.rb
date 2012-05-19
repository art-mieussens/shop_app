#coding: utf-8

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
    date = Time.mktime params[:date][:year], params[:date][:month], params[:date][:day]
    @book = Spreadsheet::Workbook.new
    @sheet = @book.create_worksheet :name => "Existencias"
    @sheet[0,0] = 'Homy Hogar'
    @sheet[1,0] = "Existencias a #{params_to_datetime(params[:date]).strftime("%d/%m/%Y - %H:%M.%S")}"
    
    @sheet[3,0] = 'Código'
    @sheet[3,1] = 'Categoría'
    @sheet[3,2] = 'Descripción'
    @sheet[3,3] = 'Cantidad'
    @sheet[3,4] = 'Costo unitario'
    @sheet[3,5] = 'Total'
    
    @row = 5
      
    @suppliers = Bussiness.where(:supplier => true).order(:name)
    @total_q = 0
    @total_c = 0.0
    @suppliers.each do |s|
      @supplier_total_q = 0
      @supplier_total_c = 0.0
      @sheet[@row,0] = s.name
      @row += 1
      @products = Product.where(:supplier_id => s.id).order(:code)
      @products.each do |p|
        @q = p.quantity(date)
        unless @q == 0
          @sheet[@row,0] = p.code
          @sheet[@row,1] = p.product_category.name
          @sheet[@row,2] = p.description
          @sheet[@row,3] = @q
          @uc = p.unit_cost(date)
          @sheet[@row,4] = @uc
          @c = @q * @uc
          @sheet[@row,5] = @c
          @supplier_total_q += @q
          @supplier_total_c += @c
          @row += 1
        end
      end
      @row += 1
      @sheet[@row,2] = "Total"
      @sheet[@row,3] = @supplier_total_q
      @sheet[@row,5] = @supplier_total_c
      @total_q += @supplier_total_q
      @total_c += @supplier_total_c
      @row += 1
    end
    @row += 1
    @sheet[@row,2] = "Total general"
    @sheet[@row,3] = @total_q
    @sheet[@row,5] = @total_c
            
    @file_name = "data/existences/existencias-#{params_to_datetime(params[:date]).strftime("%Y%m%d-%H%M%S")}.xls"
    @book.write @file_name
    send_file @file_name, :type => 'application/xls'
  end
    
end

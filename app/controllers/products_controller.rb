class ProductsController < ApplicationController
  
  def allowed?(action)
    true
  end
  
  def new
    @product = Product.new
    @categories = ProductCategory.order(:lft).map do |c|
       c.name = "&nbsp;".html_safe * 2 * c.level? + c.name
       c
    end
    @suppliers = Bussiness.where(:supplier => true).order(:name)
  end
  
  def create
    @product = Product.new(params[:product])
      if @product.save
        redirect_to products_url, :notice => "Nuevo producto creado."
      else
        @categories = ProductCategory.order(:name)
        @suppliers = Bussiness.where(:supplier => true).order(:name)
        render new_product_url
      end
  end
  
  def index
    @categories = ProductCategory.order(:lft).map do |c| #indented categories select box
       c.name = "&nbsp;".html_safe * 2 * c.level? + c.name
       c
    end
    @suppliers = Bussiness.where(:supplier => true)
    if params[:search] || params[:product_category_id] || params[:supplier_id]
      @products = Product.scoped
      @products = @products.where({:bar_code.matches => "%#{params[:search]}%"} |
                                  {:code.matches => "%#{params[:search]}%"} |
                                  {:description.matches => "%#{params[:search]}%"})
      unless params[:product_category_id].blank?
        @products = @products.where(:product_category_id.in => ProductCategory.find(params[:product_category_id]).full_set.map {|c| c.id})
      end
      unless params[:supplier_id].blank?
        @products = @products.where(:supplier_id => params[:supplier_id] )
      end
      @references_total = @products.count
      @products_total = @products.collect{|p| p.quantity}.inject(:+)
      @products = @products.order(:description).page(params[:page]).per(15)
    end
  end
  
  def show
    @product = Product.find(params[:id])
  end
  
  def edit
    @product = Product.find(params[:id])
    @categories = ProductCategory.order(:name)
    @suppliers = Bussiness.where(:supplier => true).order(:name)
  end
  
  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to products_url, :notice => "Producto modificado."
    else
      @categories = ProductCategory.order(:name)
      @suppliers = Bussiness.where(:supplier => true).order(:name)
      render :action => :edit
    end
  end
  
  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      redirect_to products_url, :notice => "Producto borrado."
    else
      redirect_back
    end
  end
  
  def list_inventory_pending
    #@products = nunca revisados de más de 2 meses + revisados más viejos que no estén en cero
    
    
     
  end
    
end

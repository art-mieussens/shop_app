# encoding: utf-8

class ProductTransformationLinesController < ApplicationController

  def allowed?(action)
    true
  end
  
  def new
  end
  
  def create
    @product_transformation = Product.find(params[:product_id]).product_transformation
    params[:product_transformation_line][:product_id] = params[:product_id]
    params[:product_transformation_line][:unit_cost] = to_decimal params[:product_transformation_line][:unit_cost]
    if @product_transformation.product_transformation_lines.create(params[:product_transformation_line])
      redirect_to product_transformation_product_transformation_lines_url(@product_transformation), :notice => "Nuevo producto añadido a la transformación-"
    else
      redirect_to :back
    end
  end
    
  def index
    @product_transformation = Product.find(params[:product_id]).product_transformation
    @product_transformation_lines = ProductTransformationLine.where(:product_transformation_id => params[:product_transformation_id]).order("created_at DESC").page(params[:page]).per(10)
    @categories = ProductCategory.order(:lft).map do |c| #indented categories select box
       c.name = "&nbsp;".html_safe * 2 * c.level? + c.name
       c
    end
    @products = Product.scoped.where(:supplier_id => @product_transformation.product.supplier_id)
    if params[:search] || params[:product_category_id]
      @products = @products.where({:bar_code.matches => "%#{params[:search]}%"} |
                                  {:code.matches => "%#{params[:search]}%"} |
                                  {:description.matches => "%#{params[:search]}%"}) unless params[:search].blank?
      @products = @products.where(:product_category_id.in => ProductCategory.find(params[:product_category_id]).full_set.map {|c| c.id}) unless params[:product_category_id].blank?
      @products = @products.order(:description).page(params[:page]).per(5)
    else
      @products = nil    
    end
  end
  
  def edit
    @product_transformation_line = ProductTransformationLine.find(params[:id])
  end
  
  def update
    @product_transformation_line = ProductTransformationLine.find(params[:id])
    if @product_transformation_line.update_attributes(params[:product_transformation_line])
      redirect_to product_product_transformation_path(@product_transformation_line.product_transformation.product), :notice => "Linea modificada."
    else
      redirect_to :back, :notice => "No se ha podido modificar la linea."
    end
  end 
  
  def destroy
    @product_transformation = ProductTransformation.find(params[:product_transformation_id])
    @product_transformation_line = ProductTransformationLine.find(params[:id])
    if @product_transformation_line.destroy
      redirect_to product_transformation_product_transformation_lines_path(@product_transformation), :notice => "Producto eliminado."
    else
      redirect_to :back, :notice => "No se ha podido eliminar el producto."
    end
  end

end

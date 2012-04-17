# encoding: utf-8

class MerchandiseReceptionLinesController < ApplicationController
  
  def allowed?(action)
    true
  end
  
  def new
  end
  
  def create
    @merchandise_reception = MerchandiseReception.find(params[:merchandise_reception_id])
    params[:merchandise_reception_line][:product_id] = params[:product_id]
    params[:merchandise_reception_line][:unit_cost] = to_decimal params[:merchandise_reception_line][:unit_cost]
    if @merchandise_reception.merchandise_reception_lines.create(params[:merchandise_reception_line])
      redirect_to merchandise_reception_merchandise_reception_lines_url(@merchandise_reception), :notice => "Nuevo producto añadido a albarán."
    else
      redirect_to :back
    end
  end
    
  def index
    @merchandise_reception = MerchandiseReception.find(params[:merchandise_reception_id])
    @merchandise_reception_lines = MerchandiseReceptionLine.where(:merchandise_reception_id => params[:merchandise_reception_id]).order("created_at DESC").page(params[:page]).per(10)
    @categories = ProductCategory.order(:lft).map do |c| #indented categories select box
       c.name = "&nbsp;".html_safe * 2 * c.level? + c.name
       c
    end
    @products = Product.scoped.where(:supplier_id => @merchandise_reception.supplier_id)
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
    @merchandise_reception = MerchandiseReception.find(params[:merchandise_reception_id])
    @merchandise_reception_line = MerchandiseReceptionLine.find(params[:id])
  end
  
  def update
    @merchandise_reception_line = MerchandiseReceptionLine.find(params[:id])
    params[:merchandise_reception_line][:unit_cost] = to_decimal params[:merchandise_reception_line][:unit_cost]    
    if @merchandise_reception_line.update_attributes(params[:merchandise_reception_line])
      redirect_to merchandise_reception_merchandise_reception_lines_path(@merchandise_reception), :notice => "Linea de albarán modificada."
    else
      redirect_to :back, :notice => "No se ha podido modificar la linea de albarán."
    end
  end 
  
  def destroy
    @merchandise_reception = MerchandiseReception.find(params[:merchandise_reception_id])
    @merchandise_reception_line = MerchandiseReceptionLine.find(params[:id])
    if @merchandise_reception_line.destroy
      redirect_to merchandise_reception_merchandise_reception_lines_path(@merchandise_reception), :notice => "Linea de albarán eliminada."
    else
      redirect_to :back, :notice => "No se ha podido eliminar la linea de albarán."
    end
  end
  
end

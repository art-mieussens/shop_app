# encoding: utf-8

class ProductTransformationsController < ApplicationController
  
  def allowed?(action)
    true
  end
  
  def create
    @product = Product.find(params[:product_id])
    @product_transformation = ProductTransformation.new
    @product_transformation.product_id = @product.id
    @product_transformation.quantity = 1
    if @product_transformation.save
      redirect_to edit_product_product_transformation_path(@product)
    end
  end
  
  def index
    @product_transformations = ProductTransformation.all.reject{|pt| pt.product.quantity == 0 }
  end
  
  def show
    @product = Product.find(params[:product_id])
    @product_transformation = @product.product_transformation
    @product_transformation_lines = @product_transformation.product_transformation_lines
  end
  
  def edit
    @product = Product.find(params[:product_id])
    @product_transformation = @product.product_transformation
  end  
  
  def update
    @product_transformation = Product.find(params[:product_id]).product_transformation
    if @product_transformation.update_attributes(params[:product_transformation])
      redirect_to product_product_transformation_url(@product), :notice => "Transformación modificada."
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @product_transformation = Product.find(params[:product_id]).product_transformation
    if @product_transformation.destroy
      redirect_to products_url, :notice => "Transformación borrada"
    end
  end

  def new_product
    @product = Product.find(params[:product_id])
    @product_transformation = @product.product_transformation
    @product_transformation_line = ProductTransformationLine.new
  end
  
  def create_product
    @product = Product.find(params[:product_id])
    @product_transformation = @product.product_transformation
    @new_product = Product.new
    @new_product.code = @product.code + params[:extra_code]
    @new_product.description = params[:description]
    @new_product.supplier_id = @product.supplier_id
    @new_product.product_category_id = @product.product_category_id
    @new_product.for_sale = true
    @new_product.vat = @product.vat 
    if @new_product.save
      @new_ptl = ProductTransformationLine.new
      @new_ptl.product_transformation_id = @product_transformation.id
      @new_ptl.product_id = @new_product.id
      @new_ptl.quantity = 1
      @new_ptl.weight = 1
      if @new_ptl.save
        redirect_to product_product_transformation_url(@product), :notice => "Nuevo producto creado."
      else
        render new_product_product_product_transformation_url(@product), :error => "No se pudo añadir el producto."
      end
    else
      render new_product_product_product_transformation_url(@product), :error => "No se pudo crear el producto."
    end
  end

  def apply
    @product_transformation = ProductTransformation.find(params[:product_transformation_id])
    @actual_unit_cost = @product_transformation.product.unit_cost
    @times_applied = @product_transformation.product.quantity.quo(@product_transformation.quantity)
    @product_transformation_lines = @product_transformation.product_transformation_lines
    if @product_transformation_lines
      @total_weight = @product_transformation_lines.map{|ptl| ptl.weight }.inject(:+)
      @product_transformation_lines.each do |tl|
        InventoryMovement.create({ :product_id => tl.product_id,
                                   :quantity => tl.quantity * @times_applied,
                                   :unit_cost => (@actual_unit_cost * @product_transformation.quantity / tl.quantity) * (tl.weight / @total_weight) })
      end
      InventoryMovement.create({ :product_id => @product_transformation.product_id,
                                 :quantity => -@times_applied * @product_transformation.quantity,
                                 :unit_cost => @actual_unit_cost })
      redirect_to product_transformations_url, :notice => "Transformación aplicada."
    else
      flash[:error] = "La transformación no se puede aplicar."
      redirect_to product_transformations_url
    end
  end

end

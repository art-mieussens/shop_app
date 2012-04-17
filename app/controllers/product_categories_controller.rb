# encoding: utf-8

class ProductCategoriesController < ApplicationController
  
  def allowed?(action)
    true
  end
  
  def new
    @parent = ProductCategory.find(params[:product_category_id]) if params[:product_category_id]
    @product_category = ProductCategory.new
  end
  
  def create
    @product_category = ProductCategory.new(params[:product_category])
    if @product_category.save
      if params[:product_category_id]
        @parent = ProductCategory.find(params[:product_category_id])
        @product_category.parent_id = params[:product_category_id]
        if @parent.add_child(@product_category)
          redirect_to product_categories_url, :notice => "Nueva subcategoría creada"
        end
      else
        redirect_to product_categories_url, :notice => "Nueva categoría de producto creada."
      end
    else
      render new_product_category_path
    end
  end
  
  def index
    @roots = ProductCategory.all_roots
  end
  
  def show
    @product_category = ProductCategory.find(params[:id])
    @products = Product.find_by_product_category_id(params[:id])
  end
  
  def edit
    @product_category = ProductCategory.find(params[:id])
  end
  
  def update
    @product_category = ProductCategory.find(params[:id])
    if @product_category.update_attributes(params[:product_category])
      redirect_to product_categories_url, :notice => 'Categoría de productos modificada'
    else
      render :action => :edit
    end
  end
  
  def destroy
    @product_category = ProductCategory.find(params[:id])
    @product_category.full_set.each do |category|
      category.products.each do |product|
        category.products.delete(product)
      end
      category.destroy
    end
    redirect_to product_categories_url, :notice => "Categoría de producto borrada."
  end
  
  

  
end

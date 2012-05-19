class InventoryBalancesController < ApplicationController
  
  def allowed?(action)
    true
  end
  
  def new
      @product = Product.find params[:product_id]
      @inventory_balance = InventoryBalance.new
  end

  def create
    @product = Product.find(params[:product_id])
    params[:inventory_balance][:creator_id] = session[:user_id]
    @inventory_balance = @product.inventory_balances.create(params[:inventory_balance])
    @inventory_balance.created_at = Time.mktime(2012,1,1)
    if @inventory_balance.save
      redirect_to product_inventory_movements_url(@product), :notice => "Nuevo balance de inventario creado."
    else
      render new_product_inventory_balance_path(@product)
    end
  end
  
  def index
  end
  
  def destroy
  end
  
end

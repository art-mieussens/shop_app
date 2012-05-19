class InventoryMovementsController < ApplicationController
  
  def allowed?(action)
    true
  end
  
  def index
    @product = Product.find(params[:product_id])
    @last_inventory_balance = InventoryBalance.where(:product => @product).last
    @inventory_movements = InventoryMovement.where(:product => @product)
    if @last_inventory_balance.present?
      @inventory_movements = @inventory_movements.where "created_at > ?", @last_inventory_balance.created_at
    end
  end
  
end

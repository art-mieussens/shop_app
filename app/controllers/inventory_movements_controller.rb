class InventoryMovementsController < ApplicationController
  
  def allowed?(action)
    true
  end
  
  def index
    if params[:product_id]
      if @product = Product.find(params[:product_id])
        @inventory_movements = InventoryMovement.where :product => @product
      else
        @inventory_movements = nil
      end
    else
      @inventory_movements = InventoryMovement.all.order
    end
    @inventory_movements.order("created_at DESC")
  end
  
end

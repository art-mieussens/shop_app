class InventoryBalancesController < ApplicationController
  validates :product_id, :quantity, :unit_cost, :created_by, :presence => true
  
  def allowed?(action)
    true
  end
  
  def new
  end

  def create
  end
  
  def index
  end
  
  def destroy
  end
  
end

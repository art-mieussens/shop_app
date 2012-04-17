class InventoryBalance < ActiveRecord::Base
  
  belongs_to :inventory
  belongs_to :product
  
end

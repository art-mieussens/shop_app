class InventoryBalance < ActiveRecord::Base

  belongs_to :product
  belongs_to :creator, :class_name => "Person"
  
end

class InventoryBalance < ActiveRecord::Base
  
  validates :product_id, :quantity, :unit_cost, :creator_id, :presence => true

  belongs_to :product
  belongs_to :creator, :class_name => "Person"
  
end

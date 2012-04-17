class InventoryMovement < ActiveRecord::Base
  
  belongs_to :product
  belongs_to :originator, :polymorphic => true
  has_one :merchandise_reception_line
  
end

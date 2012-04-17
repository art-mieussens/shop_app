class SaleLine < ActiveRecord::Base
  belongs_to :sale
  belongs_to :product
  belongs_to :rate
  has_one :inventory_movement, :as => :originator
  
  validates_presence_of :product_id
  validates_presence_of :quantity
  validates_presence_of :rate_id
  validates_presence_of :price
end

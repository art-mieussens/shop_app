class Inventory < ActiveRecord::Base
  
  belongs_to :employee, :class_name => 'Person'
  has_many :inventory_balances
  
  validates_presence_of :date, :employee_id
  validates_uniqueness_of :date
  
end

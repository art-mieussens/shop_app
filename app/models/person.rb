class Person < ActiveRecord::Base
  
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :nif, :allow_blank => true
  
  has_many :received_merchandise_receptions, :class_name => :merchandise_receptions, :foreign_key => 'received_by'
  has_many :processed_mercahndise_reception, :class_name => :merchandise_receptions, :foreign_key => 'processed_by'

  has_many :sales #Sale.seller
  has_many :sales, :as => :customer #Sale.customer
  
  has_many :inventory_balances
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
end

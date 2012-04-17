class Bussiness < ActiveRecord::Base
  
  has_many :products #supplier
  has_many :merchandise_receptions #reception notes
  has_many :sales, :as => :customer #customer
  
  validates_presence_of :name
  
end

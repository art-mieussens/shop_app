class Rate < ActiveRecord::Base
  
  has_many :sales
  has_many :sale_lines
  
end

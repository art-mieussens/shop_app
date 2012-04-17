class ProductTransformation < ActiveRecord::Base
  
  belongs_to :product
  has_many :product_transformation_lines, :dependent => :destroy
  accepts_nested_attributes_for :product_transformation_lines
  
end

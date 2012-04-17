class ProductTransformationLine < ActiveRecord::Base
  
  belongs_to :product_transformation
  belongs_to :product
  
end

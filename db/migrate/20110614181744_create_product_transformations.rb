class CreateProductTransformations < ActiveRecord::Migration
  def self.up
    create_table :product_transformations do |t|
      t.integer :product_id
      t.decimal :quantity
      
      t.timestamps
    end
  end

  def self.down
    drop_table :product_transformations
  end
end

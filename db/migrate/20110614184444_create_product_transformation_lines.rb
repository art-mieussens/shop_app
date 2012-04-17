class CreateProductTransformationLines < ActiveRecord::Migration
  def self.up
    create_table :product_transformation_lines do |t|
      t.integer :product_transformation_id, :product_id
      t.decimal :quantity, :weight

      t.timestamps
    end
  end

  def self.down
    drop_table :product_transformation_lines
  end
end

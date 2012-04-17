class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :description, :code, :bar_code
      t.integer :supplier_id, :product_category_id
      t.boolean :for_sale
      
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end

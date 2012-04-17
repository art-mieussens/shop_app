class CreateSaleLines < ActiveRecord::Migration
  def self.up
    create_table :sale_lines do |t|
      t.integer :sale_id
      t.integer :product_id
      t.integer :quantity
      t.integer :rate_id
      t.decimal :price
      t.integer :inventory_movement_id
      t.boolean :closed

      t.timestamps
    end
  end

  def self.down
    drop_table :sale_lines
  end
end

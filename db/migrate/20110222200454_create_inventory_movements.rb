class CreateInventoryMovements < ActiveRecord::Migration
  def self.up
    create_table :inventory_movements do |t|
      t.integer :product_id, :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :inventory_movements
  end
end

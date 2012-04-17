class CreateInventoryBalances < ActiveRecord::Migration
  def self.up
    create_table :inventory_balances do |t|
      t.integer :inventory_id, :product_id, :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :inventory_balances
  end
end

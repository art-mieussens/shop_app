class EditFieldsForInventoryBalances < ActiveRecord::Migration
  def self.up
    change_table :inventory_balances do |t|
      t.integer :created_by
      t.remove :inventory_id
    end
  end

  def self.down
    change_table :inventory_balances do |t|
      t.remove  :created_by
      t.integer :inventory_id
    end
  end
end

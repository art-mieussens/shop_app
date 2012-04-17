class AddPolyToInventoryMovements < ActiveRecord::Migration
  def self.up
    change_table :inventory_movements do |t|
      t.references :originator, :polymorphic => true
    end
  end

  def self.down
    remove_columns(:inventory_movements, :parent_id, :parent_type)
  end
end

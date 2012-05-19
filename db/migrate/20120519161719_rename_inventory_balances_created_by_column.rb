class RenameInventoryBalancesCreatedByColumn < ActiveRecord::Migration
  def self.up
    remove_column(:inventory_balances, :created_by)
    add_column(:inventory_balances, :creator_id, :integer)
  end

  def self.down
    add_column(:inventory_balances, :created_by, :integer)
    remove_column(:inventory_balances, :creator_id)
  end
end
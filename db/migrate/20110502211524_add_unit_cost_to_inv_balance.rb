class AddUnitCostToInvBalance < ActiveRecord::Migration
  def self.up
    add_column(:inventory_balances, :unit_cost, :decimal, :precission => 2)
  end

  def self.down
    remove_column(:inventory_balances, :unit_cost)
  end
end

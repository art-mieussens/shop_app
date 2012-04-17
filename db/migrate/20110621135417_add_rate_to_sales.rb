class AddRateToSales < ActiveRecord::Migration
  def self.up
    add_column(:sales, :rate_id, :integer)
  end

  def self.down
    remove_column(:sales, :rate_id)
  end
end

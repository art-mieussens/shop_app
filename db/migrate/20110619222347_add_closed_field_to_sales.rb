class AddClosedFieldToSales < ActiveRecord::Migration
  def self.up
    add_column(:sales, :closed, :boolean)
  end

  def self.down
    remove_column(:sales, :closed)
  end
end

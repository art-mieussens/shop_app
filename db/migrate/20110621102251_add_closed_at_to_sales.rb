class AddClosedAtToSales < ActiveRecord::Migration
  def self.up
    add_column(:sales, :closed_at, :datetime)
  end

  def self.down
    remove_column(:sales, :closed_at)
  end
end

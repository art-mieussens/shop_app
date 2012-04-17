class AddProductIdAndQuantityFieldsToMrl < ActiveRecord::Migration
  def self.up
    add_column(:merchandise_reception_lines, :product_id, :int)
    add_column(:merchandise_reception_lines, :quantity, :int)
  end

  def self.down
    remove_column(:merchandise_reception_lines, :product_id)
    remove_column(:merchandise_reception_lines, :quantity)
  end
end

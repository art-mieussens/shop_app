class AddFieldsToSale < ActiveRecord::Migration
  def self.up
    add_column(:sales, :payed, :boolean)
    add_column(:sales, :card, :boolean)
    add_column(:sales, :payment, :decimal)
  end

  def self.down
    remove_column(:sales, :payed)
    remove_column(:sales, :card)
    remove_column(:sales, :payment)  
  end
end

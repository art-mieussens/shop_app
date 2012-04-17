class CreateSales < ActiveRecord::Migration
  def self.up
    create_table :sales do |t|
      t.integer :customer_id
      t.integer :customer_type
      t.integer :seller_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sales
  end
end

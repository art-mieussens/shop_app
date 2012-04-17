class CreateMerchandiseReceptions < ActiveRecord::Migration
  def self.up
    create_table :merchandise_receptions do |t|
      t.text :code
      t.integer :supplier_id
      t.datetime :received_at
      t.integer :received_by, :processed_by
      t.decimal :vat_cost, :precission => 2
      t.decimal :transport_cost, :precission => 2
      t.decimal :other_cost, :precission => 2 
      t.boolean :closed
      t.text :notes
      
      t.timestamps
    end
  end

  def self.down
    drop_table :merchandise_receptions
  end
end

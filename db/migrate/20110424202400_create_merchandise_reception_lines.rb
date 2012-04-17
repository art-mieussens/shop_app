class CreateMerchandiseReceptionLines < ActiveRecord::Migration
  def self.up
    create_table :merchandise_reception_lines do |t|
      t.integer :merchandise_reception_id, :inventory_movement_id
      t.decimal :unit_cost, :precission => 2
      
      t.timestamps
    end
  end

  def self.down
    drop_table :merchandise_reception_lines
  end
end

class CreateInventories < ActiveRecord::Migration
  def self.up
    create_table :inventories do |t|
      t.datetime :date
      t.integer :employee_id

      t.timestamps
    end
  end

  def self.down
    drop_table :inventories
  end
end

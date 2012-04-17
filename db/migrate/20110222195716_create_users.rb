class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :hashed_password, :salt
      t.integer :person_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

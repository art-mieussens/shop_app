class CreateAppointments < ActiveRecord::Migration
  def self.up
    create_table :contact_book_appointments do |t|
      t.integer :person_id
      t.datetime :time
      t.string :location
      t.text :notes
      
      t.timestamps
    end
  end

  def self.down
    drop_table :appointments
  end
end

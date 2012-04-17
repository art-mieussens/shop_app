class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contact_book_contacts do |t|
      t.string :title
      t.integer :bussiness_id, :person_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end

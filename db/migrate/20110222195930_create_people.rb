class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string  :first_name, :last_name,
                :nif,
                :email,
                :address1, :address2, :postal_code, :city, :state, :country,
                :home_phone, :bussiness_phone, :cell_phone
      t.boolean :customer, :employee
      t.text    :notes
      
      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end

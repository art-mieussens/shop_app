class CreateBussinesses < ActiveRecord::Migration
  def self.up
    create_table :bussinesses do |t|
      t.string  :name, :fiscal_name,
                :cif,
                :address1, :address2, :postal_code, :city, :state, :country,
                :phone, :fax, :email, :website
      t.boolean  :customer, :supplier
      t.text  :notes
                
      t.timestamps
    end
  end

  def self.down
    drop_table :bussinesses
  end
end

class AddFieldsToMerchandiseReception < ActiveRecord::Migration
  def self.up
    change_table :merchandise_receptions do |t|
      t.decimal :bi18sum, :bi8sum, :bi4sum,
                :vat18sum, :vat8sum, :vat4sum,
                :req18sum, :req8sum, :req4sum, :precission => 2
      t.decimal :discount, :precission => 2
      t.remove :vat_cost
    end
  end

  def self.down
    change_table :merchandise_receptions do |t|
      t.remove  :bi18sum, :bi8sum, :bi4sum,
                :vat18sum, :vat8sum, :vat4sum,
                :req18sum, :req8sum, :req4sum, :discount
      t.decimal :vat_cost, :precission => 2
    end
  end
end

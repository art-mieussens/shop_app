class AddTicketNumber < ActiveRecord::Migration
  def self.up
    add_column(:sales, :ticket_number, :integer)
  end

  def self.down
    remove_column(:sales, :ticket_number)
  end
end

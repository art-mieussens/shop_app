class AddInvoiceCodeAndRenameCodeForMercRecept < ActiveRecord::Migration
  def self.up
    add_column(:merchandise_receptions, :invoice_code, :string)
    rename_column(:merchandise_receptions, :code, :reception_note_code)
  end

  def self.down
    remove_column(:merchandise_receptions, :invoice_code)
    rename_column(:merchandise_receptions, :reception_note_code, :code)
  end
end

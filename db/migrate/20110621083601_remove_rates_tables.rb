class RemoveRatesTables < ActiveRecord::Migration
  def self.up
    drop_table(:rates)
  end

  def self.down
    create_table(:rates)
  end
end

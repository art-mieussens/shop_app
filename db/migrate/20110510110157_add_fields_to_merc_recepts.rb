class AddFieldsToMercRecepts < ActiveRecord::Migration
  def self.up
    change_table :merchandise_receptions do |t|
      t.decimal :sum18, :sum8, :sum4,
                :disc18, :disc8, :disc4
    end
  end

  def self.down
    change_table :merchandise_receptions do |t|
      t.remove  :sum18, :sum8, :sum4,
                :disc18, :disc8, :disc4
    end
  end
end

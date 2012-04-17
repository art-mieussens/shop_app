class AddTodoCategory < ActiveRecord::Migration
  def self.up
    cat = ProductCategory.new
    cat.id = 1
    cat.lft = 1
    cat.rgt = 2
    cat.name = "Todo"
    cat.save
  end

  def self.down
    cat = ProductCategory.find_by_name('Todo')
    cat.destroy
  end
end

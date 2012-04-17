class AddRootUser < ActiveRecord::Migration
  def self.up
    user = User.new
    user.id = 1
    user.name = "root"
    user.password = "root"
    user.save
  end

  def self.down
    user = User.find_by_name("root")
    user.destroy
  end
end
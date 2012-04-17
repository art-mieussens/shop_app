class CrearRolRoot < ActiveRecord::Migration
  def self.up
    rol = Role.new
    rol.id = 1
    rol.lft = 1
    rol.rgt = 2
    rol.name = "root"
    rol.save
  end

  def self.down
    rol = Role.find_by_name('Todo')
    rol.destroy
  end
end

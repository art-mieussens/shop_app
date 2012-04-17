class Role < ActiveRecord::Base
  
  acts_as_nested_set
  
  has_many :role_assignments
  has_many :users, :through => :role_assignments
  
  validates_presence_of :name
  validates_uniqueness_of :name

end

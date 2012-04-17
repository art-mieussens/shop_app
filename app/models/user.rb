require 'digest/sha2' # Encryption library

class User < ActiveRecord::Base
  
  belongs_to :person
  has_many :role_assignments
  has_many :roles, :through => :role_assignments

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_confirmation_of :password
  validate :password_must_be_present

  attr_accessor :password_confirmation
  attr_reader :password

  class << self
    def authenticate(name, password)
      if user = find_by_name(name)
        if user.hashed_password == encrypt_password(password, user.salt)
          user
        end
      end
    end

    def encrypt_password(password, salt)
      Digest::SHA2.hexdigest(password + "wibble" + salt)
    end
  end

  def password=(password) # 'password' is a virtual attribute
    @password = password
    if password.present?
      self.salt = self.object_id.to_s + rand.to_s # generate salt
      self.hashed_password = self.class.encrypt_password(password, salt) # generate encrypted password
    end
  end

private

  def password_must_be_present
    errors.add(:password, "Missing password") unless hashed_password.present?
  end
  
end

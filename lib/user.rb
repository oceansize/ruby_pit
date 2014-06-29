# bcrypt will generate the password hash
require 'bcrypt'
require "dm-validations"

class User

  include DataMapper::Resource

  property :id              , Serial
  property :email           , String
  property :password_digest , Text
  # This will store both the password and the Salt
  # It's text and not string because string holds
  # 50 characters by default which is not enough
  # for the hash and salt.

  attr_reader   :password
  attr_accessor :password_confirmation

  # this is datamapper's method of validating the model.
  # The model will not be saved unless both password
  # and password_confirmation are the same
  # read more about it in the documentation
  # http://datamapper.org/docs/validations.html
  validates_confirmation_of :password

  # when assigned the password, we don't store it directly
  # instead, we generate a password digets, that looks like
  # this: "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"
  # and save it in the database. This digest, provided by
  # bcrypt has both the password hash and salt. We save
  # it to the database instead of the plain password
  # for security reasons.

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

end
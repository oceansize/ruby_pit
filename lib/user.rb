# bcrypt will generate the password hash
require 'bcrypt'

class User

  include DataMapper::Resource

  property :id, Serial
  property :email, String

  # This will sotre both the password and the Salt
  # It's text and not string because string holds
  # 50 characters by default which is not enough
  # for the hash and salt.
  property :password_digest, Text

  # when assigned the password, we don't store it directly
  # instead, we generate a password digets, that looks like
  # this: "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"
  # and save it in the database. This digest, provided by
  # bcrypt has both the password hash and salt. We save
  # it to the database instead of the plain password
  # for security reasons.

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

end
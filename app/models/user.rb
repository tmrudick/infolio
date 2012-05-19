class User < ActiveRecord::Base
  acts_as_authentic
  attr_accessible :crypted_password, :email, :password_salt, :persistence_token, :password, :password_confirmation
end

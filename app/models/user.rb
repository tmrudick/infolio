class User < ActiveRecord::Base
  has_many :services
end

class User < ActiveRecord::Base
  has_many :services
  attr_accessible :twitter
end

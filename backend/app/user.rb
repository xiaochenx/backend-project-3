class User < ActiveRecord::Base
    has_many :gifts
end
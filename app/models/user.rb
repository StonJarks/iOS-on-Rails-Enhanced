class User < ActiveRecord::Base
	validates_presence_of :device_token
	validates_uniqueness_of :device_token
end

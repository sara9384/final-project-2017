class User < ActiveRecord::Base
	has_many :messages
	has_many :groupusers
	has_many :groups, :through => :groupusers
end
class Group < ActiveRecord::Base
	has_many :groupusers
	has_many :users, :through => :groupusers
end
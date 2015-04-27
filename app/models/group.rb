class Group < ActiveRecord::Base
	has_many :groupusers
	has_many :users, :through => :groupusers
	has_many :messages

	include BCrypt

	  def password
	    @password ||= Password.new(group_password_hash)
	  end

	  def password=(new_password)
	    @password = Password.create(new_password)
	    self.group_password_hash = @password
	  end
end
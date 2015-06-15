require 'bcrypt'

class User < ActiveRecord::Base
	has_many :messages
	has_many :groupusers
	has_many :groups, :through => :groupusers

	include BCrypt

	  def password
	    @password ||= Password.new(password_hash)
	  end

	  def password=(new_password)
	    @password = Password.create(new_password)
	    self.password_hash = @password
	  end

	  def destroy
	  	@user.destroy
	  	redirect_to('/home')
	  end

end
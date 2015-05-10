class CreateUsers < ActiveRecord::Migration
  def up
  	create_table :users do |t|
	  	t.string :username
	  	t.string :email
	  	t.string :password_hash
      t.string :temp_password
  	end
  end

  def down
  	drop_table :users
  end

end

class CreateGroups < ActiveRecord::Migration
  def up
  	create_table :groups do |t|
  		t.string :group_name
  		t.string :group_password_hash
  	end
  end

  def down
  	drop_table :groups
  end

end

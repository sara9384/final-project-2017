class UsersToGroups < ActiveRecord::Migration
  def up
  	create_table :users_to_groups do |t|
  		t.integer :user_id
  		t.integer :group_id
  	end
  end

  def down
  	drop_table :users_to_groups
  end
end

class AddAdminIdToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :admin_id, :integer
  	add_index :users, :admin_id
  end
end

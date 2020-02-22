class AddWxOpenIdToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :wx_open_id, :string, limit: 50
    add_index :users, :wx_open_id
  end
end

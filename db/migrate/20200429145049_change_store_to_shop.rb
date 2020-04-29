class ChangeStoreToShop < ActiveRecord::Migration[6.0]
  def change
  	rename_table :stores, :shops
  	rename_column :product_store_assignments, :store_id, :shop_id
  	rename_column :shops, :store_name, :shop_name
  	add_index :product_store_assignments, :shop_id
  end
end

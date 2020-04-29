class AddMobileImageToShop < ActiveRecord::Migration[6.0]
  def change
  	add_column :shops, :mobile_image, :string
  	add_index :product_store_assignments, [:product_id, :shop_id]
  end
end

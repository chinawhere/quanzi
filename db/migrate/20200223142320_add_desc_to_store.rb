class AddDescToStore < ActiveRecord::Migration[6.0]
  def change
  	add_column :stores, :description, :text
  	add_column :products, :min_count, :integer, default: 1
  end
end

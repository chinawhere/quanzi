class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.integer :admin_id
      t.string  :store_name
      t.string  :avatar
      t.string  :phone_number
      t.boolean  :active,  default: false
      t.timestamps
    end
    add_index :stores, [:admin_id, :active]

    create_table :products do |t|
      t.integer :admin_id
      t.float   :price
      t.string  :title
      t.text    :description
      t.string  :front_image
      t.string  :detailed_image
      t.integer :position, default: 999
      t.boolean :active
      t.timestamps
    end
    add_index :products, :admin_id

    create_table :product_images do |t|
      t.integer  :product_id
      t.string   :mobile_image
      t.integer  :position
      t.boolean  :active
    end
    add_index :product_images, :product_id


    create_table :tags do |t|
      t.integer :admin_id
      t.string  :title
      t.integer :position, default: 999
      t.boolean :active
      t.timestamps
    end
    add_index :tags, [:admin_id, :active]


    create_table :product_tag_assignments do |t|
      t.integer :tag_id
      t.integer :product_id
      t.integer :position, default: 999
      t.timestamps
    end
    add_index :product_tag_assignments, [:product_id, :tag_id]

    create_table :product_store_assignments do |t|
      t.integer :store_id
      t.integer :product_id
      t.integer :position, default: 999
      t.timestamps
    end
    #add_index :product_store_assignments, [:store_id, :product_id]

  end
end

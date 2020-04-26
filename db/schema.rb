# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_26_154030) do

  create_table "ad_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "ad_type"
    t.string "url"
    t.string "mobile_image"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ad_type", "active"], name: "index_ad_images_on_ad_type_and_active"
  end

  create_table "addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "recipient_name"
    t.string "recipient_phone_number"
    t.string "location_title"
    t.string "location_address"
    t.string "location_details"
    t.decimal "gaode_lng", precision: 11, scale: 8
    t.decimal "gaode_lat", precision: 11, scale: 8
    t.string "address_province"
    t.string "address_city"
    t.string "address_district"
    t.boolean "is_default", default: false
    t.integer "sex"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "is_default"], name: "index_addresses_on_user_id_and_is_default"
  end

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 50
    t.string "password_hash"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.index ["name"], name: "index_admins_on_name"
  end

  create_table "product_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "mobile_image"
    t.integer "position"
    t.boolean "active"
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "product_store_assignments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "store_id"
    t.integer "product_id"
    t.integer "position", default: 999
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_id", "product_id"], name: "index_product_store_assignments_on_store_id_and_product_id"
  end

  create_table "product_tag_assignments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "product_id"
    t.integer "position", default: 999
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id", "tag_id"], name: "index_product_tag_assignments_on_product_id_and_tag_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "admin_id"
    t.float "price"
    t.string "title"
    t.text "description"
    t.string "front_image"
    t.string "detailed_image"
    t.integer "position", default: 999
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "min_count", default: 1
    t.index ["admin_id"], name: "index_products_on_admin_id"
  end

  create_table "role_assignments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "admin_id"
    t.integer "role_id"
    t.index ["admin_id", "role_id"], name: "index_role_assignments_on_admin_id_and_role_id"
    t.index ["admin_id"], name: "index_role_assignments_on_admin_id"
    t.index ["role_id"], name: "index_role_assignments_on_role_id"
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "stores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "admin_id"
    t.string "store_name"
    t.string "avatar"
    t.string "phone_number"
    t.boolean "active", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
    t.index ["admin_id", "active"], name: "index_stores_on_admin_id_and_active"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "admin_id"
    t.string "title"
    t.integer "position", default: 999
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id", "active"], name: "index_tags_on_admin_id_and_active"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "phone_number", limit: 20
    t.string "name"
    t.integer "sex"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "wx_ma_id", limit: 50
    t.string "wx_union_id", limit: 50
    t.string "source", limit: 50
    t.string "address_province"
    t.string "address_city"
    t.string "address_district"
    t.string "avatar"
    t.string "wx_open_id", limit: 50
    t.integer "admin_id"
    t.index ["admin_id"], name: "index_users_on_admin_id"
    t.index ["phone_number"], name: "index_users_on_phone_number"
    t.index ["wx_ma_id"], name: "index_users_on_wx_ma_id"
    t.index ["wx_open_id"], name: "index_users_on_wx_open_id"
    t.index ["wx_union_id"], name: "index_users_on_wx_union_id"
  end

end

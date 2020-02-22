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

ActiveRecord::Schema.define(version: 2020_02_22_170056) do

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
    t.index ["phone_number"], name: "index_users_on_phone_number"
    t.index ["wx_ma_id"], name: "index_users_on_wx_ma_id"
    t.index ["wx_open_id"], name: "index_users_on_wx_open_id"
    t.index ["wx_union_id"], name: "index_users_on_wx_union_id"
  end

end

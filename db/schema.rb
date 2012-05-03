# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120418165800) do

  create_table "bussinesses", :force => true do |t|
    t.string   "name"
    t.string   "fiscal_name"
    t.string   "cif"
    t.string   "address1"
    t.string   "address2"
    t.string   "postal_code"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "customer"
    t.boolean  "supplier"
  end

  create_table "inventories", :force => true do |t|
    t.datetime "date"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventory_balances", :force => true do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "unit_cost"
    t.integer  "created_by"
  end

  create_table "inventory_movements", :force => true do |t|
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "unit_cost"
    t.integer  "originator_id"
    t.string   "originator_type"
  end

  create_table "merchandise_reception_lines", :force => true do |t|
    t.integer  "merchandise_reception_id"
    t.integer  "inventory_movement_id"
    t.decimal  "unit_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "quantity"
  end

  create_table "merchandise_receptions", :force => true do |t|
    t.text     "reception_note_code"
    t.integer  "supplier_id"
    t.datetime "received_at"
    t.integer  "received_by"
    t.integer  "processed_by"
    t.decimal  "transport_cost"
    t.decimal  "other_cost"
    t.boolean  "closed"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invoice_code"
    t.decimal  "bi18sum"
    t.decimal  "bi8sum"
    t.decimal  "bi4sum"
    t.decimal  "vat18sum"
    t.decimal  "vat8sum"
    t.decimal  "vat4sum"
    t.decimal  "req18sum"
    t.decimal  "req8sum"
    t.decimal  "req4sum"
    t.decimal  "discount"
    t.decimal  "sum18"
    t.decimal  "sum8"
    t.decimal  "sum4"
    t.decimal  "disc18"
    t.decimal  "disc8"
    t.decimal  "disc4"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nif"
    t.string   "email"
    t.string   "address1"
    t.string   "address2"
    t.string   "postal_code"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "home_phone"
    t.string   "bussiness_phone"
    t.string   "cell_phone"
    t.boolean  "customer"
    t.boolean  "employee"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "printers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_transformation_lines", :force => true do |t|
    t.integer  "product_transformation_id"
    t.integer  "product_id"
    t.decimal  "quantity"
    t.decimal  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_transformations", :force => true do |t|
    t.integer  "product_id"
    t.decimal  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "description"
    t.string   "code"
    t.string   "bar_code"
    t.integer  "supplier_id"
    t.integer  "product_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "for_sale"
    t.integer  "products_group_id"
    t.integer  "contact_book_bussiness_id"
    t.integer  "vat"
    t.decimal  "price"
  end

  create_table "rates", :force => true do |t|
    t.string   "description"
    t.string   "expression"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sale_lines", :force => true do |t|
    t.integer  "sale_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "rate_id"
    t.decimal  "price"
    t.integer  "inventory_movement_id"
    t.boolean  "closed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "customer_type"
    t.integer  "seller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed"
    t.datetime "closed_at"
    t.integer  "rate_id"
    t.boolean  "payed"
    t.boolean  "card"
    t.decimal  "payment"
    t.integer  "ticket_number"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

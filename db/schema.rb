# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080731134814) do

  create_table "line_items", :force => true do |t|
    t.integer  "product_id",                                               :null => false
    t.integer  "quantity",                                  :default => 0, :null => false
    t.decimal  "unit_price", :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id",                                                 :null => false
  end

  add_index "line_items", ["order_id"], :name => "fk_items_order"
  add_index "line_items", ["product_id"], :name => "fk_items_product"

  create_table "orders", :force => true do |t|
    t.string   "name",       :limit => 100, :default => "", :null => false
    t.string   "email",                     :default => "", :null => false
    t.text     "address",                                   :null => false
    t.string   "pay_type",   :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "shipped_at"
  end

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "price"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",     :null => false
  end

  create_table "reviews", :force => true do |t|
    t.integer  "product_id", :null => false
    t.integer  "user_id",    :null => false
    t.text     "body",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "var",        :default => "", :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string "name", :default => "--- :null\n"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "tags_products", :force => true do |t|
    t.integer "tag_id"
    t.integer "product_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
    t.string   "password_reset_code",       :limit => 40
    t.boolean  "enabled",                                 :default => true
  end

end

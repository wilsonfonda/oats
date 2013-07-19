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

ActiveRecord::Schema.define(:version => 20130719055403) do

  create_table "billings", :force => true do |t|
    t.integer  "total_employee"
    t.integer  "price"
    t.datetime "payment_date"
    t.integer  "month"
    t.integer  "company_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "contact"
    t.boolean  "status"
    t.integer  "deposit",    :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "offices", :force => true do |t|
    t.string   "name"
    t.float    "longitude"
    t.float    "latitude"
    t.float    "longitude_min"
    t.float    "latitude_min"
    t.float    "longitude_max"
    t.float    "latitude_max"
    t.float    "range"
    t.integer  "company_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "ownerships", :force => true do |t|
    t.integer  "company_id"
    t.integer  "owner_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ownerships", ["company_id", "owner_id"], :name => "index_ownerships_on_company_id_and_owner_id", :unique => true
  add_index "ownerships", ["company_id"], :name => "index_ownerships_on_company_id"
  add_index "ownerships", ["owner_id"], :name => "index_ownerships_on_owner_id"

  create_table "presences", :force => true do |t|
    t.datetime "date"
    t.boolean  "flag"
    t.string   "note"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",                    :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "name"
    t.string   "division"
    t.string   "role",                   :limit => nil
    t.string   "access_token"
    t.integer  "office_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "worktimes", :force => true do |t|
    t.datetime "checkin"
    t.datetime "checkout"
    t.string   "place_checkin"
    t.string   "place_checkout"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end

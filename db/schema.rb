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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181118123643) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orgs", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "owner"
    t.string   "email"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "prerequisites", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "dependency_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "status"
    t.integer  "org_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["org_id"], name: "index_projects_on_org_id", using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.float    "duration"
    t.datetime "due_date"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "deptasks",    default: [],              array: true
    t.index ["project_id"], name: "index_tasks_on_project_id", using: :btree
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "org_id"
    t.integer  "status"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["org_id"], name: "index_users_on_org_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end

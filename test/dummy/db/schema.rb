# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_18_123711) do
  create_table "actors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "member_id", null: false
    t.integer "role_id", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_actors_on_member_id"
    t.index ["role_id"], name: "index_actors_on_role_id"
  end

  create_table "billing_profile_subscriptions", force: :cascade do |t|
    t.integer "billing_profile_id", null: false
    t.datetime "cancel_at"
    t.datetime "created_at", null: false
    t.datetime "current_period_end_at"
    t.json "metadata", default: {}, null: false
    t.string "slug", null: false
    t.string "status", null: false
    t.string "subscription_id", null: false
    t.string "subscription_item_id", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_profile_id"], name: "index_billing_profile_subscriptions_on_billing_profile_id"
    t.index ["slug", "billing_profile_id"], name: "idx_on_slug_billing_profile_id_ba4f664342", unique: true
    t.index ["subscription_id"], name: "index_billing_profile_subscriptions_on_subscription_id"
    t.index ["subscription_item_id"], name: "index_billing_profile_subscriptions_on_subscription_item_id"
  end

  create_table "billing_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "external_id"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.integer "workspace_id", null: false
    t.index ["external_id"], name: "index_billing_profiles_on_external_id"
    t.index ["slug", "workspace_id"], name: "index_billing_profiles_on_slug_and_workspace_id", unique: true
    t.index ["workspace_id"], name: "index_billing_profiles_on_workspace_id"
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "workspace_id", null: false
    t.index ["deleted_at"], name: "index_members_on_deleted_at"
    t.index ["slug", "workspace_id"], name: "index_members_on_slug_and_workspace_id", unique: true
    t.index ["user_id"], name: "index_members_on_user_id"
    t.index ["workspace_id"], name: "index_members_on_workspace_id"
  end

  create_table "rails_vaults", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "payload", default: {}, null: false
    t.integer "resource_id", null: false
    t.string "resource_type", null: false
    t.string "scope", null: false
    t.datetime "updated_at", null: false
    t.index ["payload"], name: "index_rails_vaults_on_payload"
    t.index ["resource_type", "resource_id"], name: "index_rails_vaults_on_resource"
    t.index ["scope"], name: "index_rails_vaults_on_scope"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "current_workspace_id"
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "workspaces", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_workspaces_on_slug", unique: true
  end

  add_foreign_key "actors", "members"
  add_foreign_key "actors", "roles"
  add_foreign_key "billing_profile_subscriptions", "billing_profiles"
  add_foreign_key "billing_profiles", "workspaces"
  add_foreign_key "members", "users"
  add_foreign_key "members", "workspaces"
  add_foreign_key "sessions", "users"
end

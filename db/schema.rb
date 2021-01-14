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

ActiveRecord::Schema.define(version: 2021_01_14_010116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_referrals", force: :cascade do |t|
    t.bigint "referral_id", null: false
    t.bigint "inviter_id", null: false
    t.boolean "reward_to_inviter_given"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inviter_id"], name: "index_user_referrals_on_inviter_id"
    t.index ["referral_id"], name: "index_user_referrals_on_referral_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "expires_on", precision: 6, null: false
    t.text "data"
    t.string "hash_representation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "referral_code"
  end

  add_foreign_key "user_referrals", "users", column: "inviter_id"
  add_foreign_key "user_referrals", "users", column: "referral_id"
  add_foreign_key "user_sessions", "users"
end

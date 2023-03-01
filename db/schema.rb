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

ActiveRecord::Schema[7.0].define(version: 2023_03_01_022707) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "ynab_accounts", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.text "name", default: "NOT ASSIGNED", null: false
    t.text "account_type", default: "NOT ASSIGNED", null: false
    t.boolean "on_budget", default: false, null: false
    t.boolean "closed", default: false, null: false
    t.text "note"
    t.bigint "balance", default: 0, null: false
    t.bigint "cleared_balance", default: 0, null: false
    t.bigint "uncleared_balance", default: 0, null: false
    t.uuid "transfer_payee_id", null: false
    t.boolean "direct_import_linked"
    t.boolean "direct_import_in_error"
    t.datetime "last_reconciled_at"
    t.bigint "debt_original_balance"
    t.text "debt_interest_rates"
    t.text "debt_minimum_payments"
    t.text "debt_escrow_amounts"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_ynab_accounts_on_uuid", unique: true
  end

  create_table "ynab_categories", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "category_group_id", default: -> { "gen_random_uuid()" }, null: false
    t.text "name", default: "NOT ASSIGNED", null: false
    t.boolean "hidden", default: false, null: false
    t.uuid "original_category_group_id"
    t.text "note"
    t.bigint "budgeted", default: 0, null: false
    t.bigint "activity", default: 0, null: false
    t.bigint "balance", default: 0, null: false
    t.text "goal_type"
    t.integer "goal_day"
    t.integer "goal_cadence"
    t.integer "goal_cadence_frequency"
    t.text "goal_creation_month"
    t.bigint "goal_target"
    t.text "goal_target_month"
    t.integer "goal_percentage_complete"
    t.integer "goal_months_to_budget"
    t.bigint "goal_under_funded"
    t.bigint "goal_overall_funded"
    t.bigint "goal_overall_left"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_ynab_categories_on_uuid", unique: true
  end

  create_table "ynab_category_groups", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.text "name", default: "NOT ASSIGNED", null: false
    t.boolean "hidden", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_ynab_category_groups_on_uuid", unique: true
  end

  create_table "ynab_transactions", force: :cascade do |t|
    t.text "uuid", default: "gen_random_uuid()", null: false
    t.date "date", default: "1900-01-01", null: false
    t.bigint "amount", default: 0, null: false
    t.text "memo"
    t.text "cleared", default: "uncleared", null: false
    t.boolean "approved", default: false, null: false
    t.text "flag_color"
    t.uuid "account_id", default: -> { "gen_random_uuid()" }, null: false
    t.text "account_name", default: "NOT ASSIGNED", null: false
    t.uuid "payee_id"
    t.text "payee_name"
    t.uuid "category_id"
    t.text "category_name", default: "Uncategorized", null: false
    t.uuid "transfer_account_id"
    t.uuid "transfer_transaction_id"
    t.uuid "matched_transaction_id"
    t.uuid "import_id"
    t.text "import_payee_name"
    t.text "import_payee_name_original"
    t.text "debt_transaction_type"
    t.boolean "deleted", default: false, null: false
    t.jsonb "subtransactions", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_ynab_transactions_on_uuid", unique: true
  end

end

class CreateYnabAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :ynab_accounts do |t|
      t.uuid :uuid, null: false, default: "NOT ASSIGNED", index: {unique: true}
      t.text :name, null: false, default: "NOT ASSIGNED"
      t.text :account_type, null: false, default: "NOT ASSIGNED"
      t.boolean :on_budget, null: false, default: false
      t.boolean :closed, null: false, default: false
      t.text :note
      t.bigint :balance, null: false, default: 0
      t.bigint :cleared_balance, null: false, default: 0
      t.bigint :uncleared_balance, null: false, default: 0
      t.uuid :transfer_payee_id, null: false, default: "NOT ASSIGNED" # references here
      t.boolean :direct_import_linked
      t.boolean :direct_import_in_error
      t.datetime :last_reconciled_at
      t.bigint :debt_original_balance
      t.text :debt_interest_rates
      t.text :debt_minimum_payments
      t.text :debt_escrow_amounts
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end

    # add_index :uuid, unique: true
  end
end

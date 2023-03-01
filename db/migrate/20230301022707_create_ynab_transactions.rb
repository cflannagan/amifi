class CreateYnabTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :ynab_transactions do |t|
      t.text :uuid, null: false, default: "gen_random_uuid()", index: {unique: true}
      t.date :date, null: false, default: "1900-01-01"
      t.bigint :amount, null: false, default: 0
      t.text :memo
      t.text :cleared, null: false, default: "uncleared"
      t.boolean :approved, null: false, default: false
      t.text :flag_color
      t.uuid :account_id, null: false, default: "gen_random_uuid()" # references here
      t.text :account_name, null: false, default: "NOT ASSIGNED"
      t.uuid :payee_id  # references here
      t.text :payee_name
      t.uuid :category_id  # references here
      t.text :category_name, null: false, default: "Uncategorized"
      t.uuid :transfer_account_id  # references here
      t.uuid :transfer_transaction_id  # references here
      t.uuid :matched_transaction_id  # references here
      t.uuid :import_id  # references here?
      t.text :import_payee_name
      t.text :import_payee_name_original
      t.text :debt_transaction_type
      t.boolean :deleted, null: false, default: false
      t.jsonb :subtransactions, array: true, null: false, default: []

      t.timestamps
    end

    # add_index :uuid, unique: true
  end
end

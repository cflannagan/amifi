class CreateYnabCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :ynab_category_groups do |t|
      t.uuid :uuid, null: false, default: "gen_random_uuid()", index: {unique: true}
      t.text :name, null: false, default: "NOT ASSIGNED"
      t.boolean :hidden, null: false, default: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end

    create_table :ynab_categories do |t|
      t.uuid :uuid, null: false, default: "gen_random_uuid()", index: {unique: true}
      # category_group_id: references category_group by uuid
      # t.references :category_group, null: false, foreign_key: true, type: :uuid
      t.uuid :category_group_id, null: false, default: 'gen_random_uuid()'
      t.text :name, null: false, default: "NOT ASSIGNED"
      t.boolean :hidden, null: false, default: false
      t.uuid :original_category_group_id
      # original_category_group_id also references category_group by uuid. can be null.
      t.text :note
      t.bigint :budgeted, null: false, default: 0
      t.bigint :activity, null: false, default: 0
      t.bigint :balance, null: false, default: 0
      t.text :goal_type
      t.integer :goal_day
      t.integer :goal_cadence
      t.integer :goal_cadence_frequency
      t.text :goal_creation_month
      t.bigint :goal_target
      t.text :goal_target_month
      t.integer :goal_percentage_complete
      t.integer :goal_months_to_budget
      t.bigint :goal_under_funded
      t.bigint :goal_overall_funded
      t.bigint :goal_overall_left
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end

    # add_index :uuid, unique: true
  end
end

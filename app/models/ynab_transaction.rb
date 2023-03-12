class YnabTransaction < ApplicationRecord
  include YnabDataImporter

  PASSIVE_INCOME_EXCLUDED_CATEGORIIES = %w[Uncategorized].freeze
  PASSIVE_INCOME_PAYEES = ['Social Security Administration', 'Credit Card Redemptions'].freeze
  SPENDING_EXCLUDED_CATEGORIES = ['Uncategorized', 'Inflow: Ready to Assign', 'Split (Multiple Categories)...'].freeze

  # YnabTransaction.after(1.day.ago.to_date)
  def self.after(date)
    where("date >= ?", date)
  end

  # NOTE: this would also inherently include reconciled
  def self.cleared
    where(cleared: %w[cleared reconciled])
  end

  def self.exclude_categories(category_names)
    where.not(category_name: category_names)
  end

  def self.exclude_hidden_categories
    joins("JOIN ynab_categories ON ynab_categories.uuid = ynab_transactions.category_id")
      .where(ynab_categories: { hidden: false })
  end

  def self.inflows
    where("amount > 0")
  end

  def self.not_disregarded
    where("memo IS NULL OR memo NOT LIKE ?", "%AMIFI:DISREGARD%")
  end

  def self.not_transferred
    where(transfer_account_id: nil)
  end

  def self.passive_income
    valid
      .inflows
      .with_payees(PASSIVE_INCOME_PAYEES)
      .exclude_categories(PASSIVE_INCOME_EXCLUDED_CATEGORIIES)
  end

  def self.spending(after = 1.year.ago.to_date)
    valid(after)
      .exclude_categories(SPENDING_EXCLUDED_CATEGORIES)
  end

  def self.sum_in_cents
    (sum(:amount) / 10.0).abs
  end

  def self.valid(after = 1.year.ago.to_date)
    cleared
      .not_transferred
      .not_disregarded
      .exclude_hidden_categories
      .after(after)
  end

  # YnabTransaction.with_payees(['Social Security Administration','Credit Card Redemptions'])
  def self.with_payees(payees)
    where(payee_name: payees)
  end
end

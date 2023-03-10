class YnabTransaction < ApplicationRecord
  include YnabDataImporter

  # YnabTransaction.with_payees(['Social Security Administration','Credit Card Redemptions'])
  def self.with_payees(payees)
    where(payee_name: payees)
  end

  def self.inflows
    where("amount > 0")
  end

  def self.not_transferred
    where(transfer_account_id: nil)
  end

  # NOTE: this would also inherently include reconciled
  def self.cleared
    where(cleared: %w[cleared reconciled])
  end

  def self.not_disregarded
    where("memo IS NULL OR memo NOT LIKE ?", "%AMIFI:DISREGARD%")
  end

  # YnabTransaction.after(1.day.ago.to_date)
  def self.after(date)
    where("date >= ?", date)
  end

  def self.exclude_categories(category_names)
    where.not(category_name: category_names)
  end

  def self.exclude_hidden_categories
    joins("JOIN ynab_categories ON ynab_categories.uuid = ynab_transactions.category_id")
      .where(ynab_categories: { hidden: false })
  end
end

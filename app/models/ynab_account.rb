class YnabAccount < ApplicationRecord
  include YnabDataImporter

  def self.active
    where(closed: false)
      .where("note IS NULL OR note NOT LIKE ?", "%AMIFI:DISREGARD%")
  end

  # by default it's just 1 day.
  # TODO: Functionality to overridefrom YNAB side setting like AMIFI:UPDATED_MONTHLY, need to think about what
  # other good values besides UPDATED_MONTHLY for potentual users of this app.
  def self.stale_last_reconciled_at
    where("last_reconciled_at < ?", Time.current - 1.day)
  end

  def self.sum_in_cents
    sum(:cleared_balance) / 10.0
  end

  # Overrides YnabDataImporter implementation
  def self.transform(accts)
    super(
      accts.map do |acct|
        acct["account_type"] = acct["type"]
        acct.except("type")
      end
    )
  end
end

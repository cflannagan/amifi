class YnabAccount < ApplicationRecord
  include YnabDataImporter

  def self.active
    where(closed: false)
      .where("note IS NULL OR note NOT LIKE ?", "%AMIFI:DISREGARD%")
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

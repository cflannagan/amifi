# A class that ties everything together (will be refactored out)
class TheFiPicture
  SWR = 0.04 # 4%
  attr :passive_income, :assets, :spending, :net_worth, :difference, :percent_of_target

  def initialize
    @passive_income = YnabTransaction.passive_income.sum_in_cents / 100.0 * TheFiPicture.swr_multipler
    @spending = YnabTransaction.spending.sum_in_cents / 100.0 * TheFiPicture.swr_multipler
    @assets = YnabAccount.active.sum_in_cents / 100.0
  end

  def difference
    net_worth - spending
  end

  # Remember, net_worth in FI context doesn't include house equity normally.
  # Should mention this to the user somehow.
  def net_worth
    assets + passive_income
  end

  def percent_of_target
    net_worth / spending
  end

  # TheFiPicture.assets
  def self.assets
    YnabAccount.active.sum_in_cents / 100.0
  end

  # TheFiPicture.passive_income
  def self.passive_income
    YnabTransaction.passive_income.sum_in_cents / 100.0 * swr_multipler
  end

  # TheFiPicture.spending
  def self.spending
    YnabTransaction.spending.sum_in_cents / 100.0 * swr_multipler
  end

  def self.swr_multipler
    1.0 / SWR
  end
end

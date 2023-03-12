# A class that ties everything together. Probably will be a model with db table eventually (recording key values among with
# a timestamp)
class TheFiPicture < ApplicationRecord
  # TheFiPicture.assets
  def self.assets
    YnabAccount.active.sum(:cleared_balance) / 1000.0
  end

  # TheFiPicture.passive_income
  def self.passive_income
    YnabTransaction
      .inflows
      .cleared
      .not_transferred
      .not_disregarded
      .exclude_hidden_categories
      .with_payees(['Social Security Administration', 'Credit Card Redemptions'])
      .exclude_categories(['Uncategorized'])
      .after(1.year.ago.to_date)
      .sum(:amount) / 1000.0 * 25.0
  end

  # TheFiPicture.spending
  def self.spending
    amt = YnabTransaction
          .cleared
          .not_transferred
          .not_disregarded
          .exclude_hidden_categories
          .exclude_categories(['Uncategorized', 'Inflow: Ready to Assign', 'Split (Multiple Categories)...'])
          .after(1.year.ago.to_date)
          .sum(:amount) / 1000.0 * 25.0
    amt.abs
  end

  # we want fi_figure to be 0, which means we reached that point.
  # And then beyond that too (positive territory), meaning we can afford to
  # push our standard of living higher
  # TheFiPicture.summary
  # def self.summary
  #   fi_figure = TheFiPicture.assets + TheFiPicture.passive_income - TheFiPicture.spending
  #   <<~TXT
  #     You are now at
  #     #{((TheFiPicture.assets + TheFiPicture.passive_income) / TheFiPicture.spending * 100.0).round(2)}%
  #     of the way to FI life.

  #     Your FI figure is currently short $#{fi_figure.abs.round(2)}. You would need to come up with
  #     $#{(fi_figure.abs / 300.0).round(2)} additional monthly income that could be reasonably classified as passive
  #     income. Other option is to downsize house to access equity. Of course, there is also a more flexible hybrid
  #     approach: doing the combination of both downsizing to access equity and creating a new passive income stream.
  #   TXT
  # end
end

class TheFiPictureController < ActionController::Base
  def index
    @fi_net_worth = TheFiPicture.assets + TheFiPicture.passive_income
    @fi_spending = TheFiPicture.spending
    @fi_figure = @fi_net_worth - @fi_spending
    @fi_pct = ((TheFiPicture.assets + TheFiPicture.passive_income) / TheFiPicture.spending * 100.0).round(2)
    @oldest_stale_reconciled_account = YnabAccount.active.stale_last_reconciled_at.order(:last_reconciled_at).first
  end
end

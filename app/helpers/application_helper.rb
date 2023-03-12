module ApplicationHelper
  def monetize(value)
    Money.new(value * 100).format
  end
end

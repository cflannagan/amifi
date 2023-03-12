Money.default_currency = Money::Currency.new("USD")
Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.locale_backend = :i18n

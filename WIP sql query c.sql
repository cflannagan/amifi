-- SELECT
-- 	EXTRACT(YEAR FROM date) AS year,
-- 	EXTRACT(MONTH FROM date) AS month,
-- 	EXTRACT(DAY FROM date) AS day,
-- 	ynab_transactions.*
-- FROM
-- 	ynab_transactions
-- 	JOIN ynab_categories ON ynab_categories.uuid = ynab_transactions.category_id
-- WHERE
-- 	ynab_transactions.cleared IN('cleared', 'reconciled')
-- 	AND ynab_transactions.transfer_account_id IS NULL
-- 	AND(memo IS NULL
-- 		OR memo NOT LIKE '%AMIFI:DISREGARD%')
-- 	AND ynab_categories.hidden = FALSE
-- 	AND(date >= '2022-03-12')
-- 	AND ynab_transactions.category_name NOT IN('Uncategorized', 'Inflow: Ready to Assign', 'Split (Multiple Categories)...')
-- ORDER BY
-- 	year, month, day, id
	

-- SELECT
-- 	year,
-- 	month,
-- -- 	EXTRACT(DAY FROM date) AS day,
-- 	sum(Month_Total) OVER (
-- 		ORDER BY year, month ASC rows 11 preceding
-- 	) AS rolling_12_month_sum
-- FROM (

-- SELECT
-- 	EXTRACT(YEAR FROM date) AS year,
-- 	EXTRACT(MONTH FROM date) AS month,
-- 	sum(amount) AS Month_Total
-- FROM
-- 	ynab_transactions
-- 	JOIN ynab_categories ON ynab_categories.uuid = ynab_transactions.category_id
-- WHERE
-- 	ynab_transactions.cleared IN('cleared', 'reconciled')
-- 	AND ynab_transactions.transfer_account_id IS NULL
-- 	AND(memo IS NULL OR memo NOT LIKE '%AMIFI:DISREGARD%')
-- 	AND ynab_categories.hidden = FALSE
-- 	AND ynab_transactions.category_name NOT IN('Uncategorized', 'Inflow: Ready to Assign', 'Split (Multiple Categories)...')
-- GROUP BY
-- 	EXTRACT(YEAR FROM date),
-- 	EXTRACT(MONTH FROM date)
-- ORDER BY
-- 	EXTRACT(YEAR FROM date),
-- 	EXTRACT(MONTH FROM date)
--     
-- ) t





WITH every_date_series AS (
	SELECT '2019-1-26'::date + s.a AS dates FROM generate_series(0,1506,1) AS s(a)
)
, every_date AS (
	SELECT
		EXTRACT(YEAR FROM dates) AS year,
		EXTRACT(MONTH FROM dates) AS month,
		EXTRACT(DAY FROM dates) AS day
	FROM every_date_series
	ORDER BY
		EXTRACT(YEAR FROM dates),
		EXTRACT(MONTH FROM dates),
		EXTRACT(DAY FROM dates)	
)
, daily_totals AS (
	SELECT
		EXTRACT(YEAR FROM date) AS year,
		EXTRACT(MONTH FROM date) AS month,
		EXTRACT(DAY FROM date) AS day,
		sum(amount) AS daily_total
	FROM
		ynab_transactions
		JOIN ynab_categories ON ynab_categories.uuid = ynab_transactions.category_id
	WHERE
		ynab_transactions.cleared IN('cleared', 'reconciled')
		AND ynab_transactions.transfer_account_id IS NULL
		AND(memo IS NULL OR memo NOT LIKE '%AMIFI:DISREGARD%')
		AND ynab_categories.hidden = FALSE
		AND ynab_transactions.category_name NOT IN('Uncategorized', 'Inflow: Ready to Assign', 'Split (Multiple Categories)...')
	GROUP BY
		EXTRACT(YEAR FROM date),
		EXTRACT(MONTH FROM date),
		EXTRACT(DAY FROM date)
	ORDER BY
		EXTRACT(YEAR FROM date),
		EXTRACT(MONTH FROM date),
		EXTRACT(DAY FROM date)
)
, daily_totals_joined AS (
	SELECT
		every_date.*, daily_totals.daily_total
	FROM
		every_date
		LEFT JOIN daily_totals ON every_date.year = daily_totals.year
			AND every_date.month = daily_totals.month
			AND every_date.day = daily_totals.day
)
SELECT
	year,
	month,
	day,
	sum(daily_total) OVER (ORDER BY year, month, day ASC ROWS 365 PRECEDING) / 1000.0 * -1 AS rolling_12_month_sum
FROM
	daily_totals_joined



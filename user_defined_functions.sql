-- Get fiscal year based on date - use defined functions
SELECT * FROM fact_forecast_monthly
WHERE customer_code=90002002 AND
get_fiscal_year(date)=2021
ORDER BY date DESC;

-- Return Month of given date
SELECT * FROM fact_forecast_monthly
WHERE customer_code=90002002 AND
get_fiscal_quarter(date)="Q4"
ORDER BY date DESC;

SELECT 
m.date,
m.product_code,
p.product,
p.variant,
m.sold_quantity,
gp.gross_price,
ROUND(m.sold_quantity * gp.gross_price,2) AS gross_total_price
 FROM fact_sales_monthly m
JOIN dim_product p 
ON m.product_code=p.product_code
JOIN fact_gross_price gp
ON
	m.product_code=gp.product_code AND
    get_fiscal_year(m.date)=gp.fiscal_year
WHERE customer_code=90002002 AND
get_fiscal_quarter_version2(date)="Q4"
ORDER BY date DESC;

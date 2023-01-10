SELECT * FROM random_tables.student_marks;

-- top 10 highest scored students
WITH student_cte AS(
SELECT
	*,
    dense_rank() over(order by marks desc) as drank
FROM student_marks)
SELECT * FROM student_cte
WHERE drank <=5;



SELECT 
SUM(amount)
 FROM random_tables.expenses; #65,800
 
SELECT 
SUM(amount)
 FROM random_tables.expenses
WHERE category='Food'; #11,800

SELECT
	*, amount*100 / SUM(amount) OVER(partition by category) AS perct
FROM expenses;

-- Calculate cumilative sum
SELECT
	*,
    SUM(amount) OVER(partition by category order by date) AS total_expense_till_date
FROM expenses
order by category, date; 

-- Get top 2 expenses for each category
WITH CTE1 AS (
SELECT
	*,
	row_number() over(partition by category order by amount desc) AS rn,
    rank() over(partition by category order by amount desc) AS rnk,
    dense_rank() over(partition by category order by amount desc) AS drank
FROM expenses)
SELECT * FROM CTE1
WHERE drank<=2;


WITH top_market_cte2 AS(
 WITH top_market_cte AS(
 SELECT
	cus.market,
	cus.region,
    ROUND(SUM(sa.sold_quantity * g.gross_price)/1000000,2) AS gross_sales_in_mlns
FROM dim_customer cus 
JOIN fact_sales_monthly sa ON
cus.customer_code = sa.customer_code
JOIN fact_gross_price g ON
g.product_code=sa.product_code
WHERE sa.fiscal_year=2021
GROUP BY cus.market,cus.region)
SELECT
	*,
    rank() OVER(partition by region order by gross_sales_in_mlns desc) AS rnk
FROM top_market_cte)
SELECT * FROM top_market_cte2
WHERE rnk<=2;




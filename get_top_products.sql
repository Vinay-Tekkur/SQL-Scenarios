CREATE DEFINER=`root`@`localhost` PROCEDURE `top_n_products_quantity`(
in_number_of_n INT,
in_fiscal_year INT
)
BEGIN
WITH product_cte2 AS(
WITH product_cte AS (
SELECT 
 prod.division,
 prod.product,
 SUM(sa.sold_quantity) AS total_quantity
 FROM dim_product prod
 JOIN fact_sales_monthly sa ON prod.product_code=sa.product_code
 WHERE sa.fiscal_year=in_fiscal_year
 group by prod.division,prod.product)
 SELECT 
 *,
  dense_rank() OVER(partition by division order by total_quantity desc) AS drank
 -- row_number() OVER(partition by division order by sa.sold_quantity) AS rn
 FROM product_cte)
 SELECT * FROM product_cte2 WHERE drank <=in_number_of_n;
END

call gdb041.top_n_products_quantity(5, 2021);

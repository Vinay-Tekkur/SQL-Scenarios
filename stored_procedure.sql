CREATE DEFINER=`root`@`localhost` PROCEDURE `get_given_market_badge`(
IN in_market VARCHAR(50),
IN in_fiscal_year YEAR,
OUT out_market_badge VARCHAR(10)
)
BEGIN
declare qty INT default 0;
IF in_market="" THEN
SET in_market="india";
end if;


SELECT
    SUM(sales.sold_quantity) into qty
FROM dim_customer cust
JOIN fact_sales_monthly sales ON cust.customer_code=sales.customer_code
WHERE get_fiscal_year(sales.date)=in_fiscal_year AND cust.market=in_market
GROUP BY cust.market;

IF qty > 5000000 THEN
	SET out_market_badge='Gold';
ELSE
SET out_market_badge='Silver';
end if;

END

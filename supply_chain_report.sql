-- The supply chain business manager wants to see which customers’ forecast accuracy 
-- has dropped from 2020 to 2021. 
-- Provide a complete report with these columns: 
-- customer_code, customer_name, market, forecast_accuracy_2020, forecast_accuracy_2021
DROP temporary table forecast_accuracy_2021;
CREATE temporary table forecast_accuracy_2020
SELECT
	customer_code,
    SUM(abs(forecast_quantity - sold_quantity))*100/ SUM(forecast_quantity) AS abs_err_per_2020
FROM fact_sales_forecast
WHERE fiscal_year=2020
GROUP BY customer_code;

CREATE temporary table forecast_accuracy_2021
SELECT
	customer_code,
    SUM(abs(forecast_quantity - sold_quantity))*100/ SUM(forecast_quantity) AS abs_err_per_2021
FROM fact_sales_forecast
WHERE fiscal_year=2021
GROUP BY customer_code;

SELECT
	forecast_2020.customer_code,
    dc.customer,
    dc.market,
    if(forecast_2020.abs_err_per_2020 > 100,0, 100-forecast_2020.abs_err_per_2020) AS forecast_accuracy_2020,
    if(forecast_2021.abs_err_per_2021 > 100,0, 100-forecast_2021.abs_err_per_2021) AS forecast_accuracy_2021
FROM forecast_accuracy_2020 forecast_2020 JOIN
forecast_accuracy_2021 forecast_2021 USING(customer_code)
JOIN dim_customer dc USING(customer_code);

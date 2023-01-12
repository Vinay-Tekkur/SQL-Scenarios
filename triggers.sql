CREATE DEFINER=`root`@`localhost` TRIGGER `fact_forecast_monthly_AFTER_INSERT` AFTER INSERT ON `fact_forecast_monthly` FOR EACH ROW BEGIN
INSERT INTO fact_sales_forecast
(date, product_code, customer_code, forecast_quantity)
VALUES
(NEW.date, NEW.product_code, NEW.customer_code, NEW.forecast_quantity)
on duplicate key update
sold_quantity = values(forecast_quantity);
END

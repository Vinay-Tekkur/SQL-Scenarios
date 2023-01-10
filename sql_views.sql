-- Create a view for gross sales. It should have the following columns,
-- date, fiscal_year, customer_code, customer, market, product_code, product, variant,
-- sold_quanity, gross_price_per_item, gross_price_total

SELECT
	sales.date,
    sales.fiscal_year,
    sales.customer_code,
    cus.customer,
    cus.market,
    pro.product,
    pro.variant,
    sales.sold_quantity,
    gross.gross_price
FROM fact_sales_monthly sales
JOIN dim_customer cus ON
	sales.customer_code=cus.customer_code
JOIN dim_product pro ON
	pro.product_code=sales.product_code
JOIN fact_gross_price gross
ON pro.product_code=gross.product_code

-- with Views
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `product_details` AS
    SELECT 
        `sales`.`date` AS `date`,
        `sales`.`fiscal_year` AS `fiscal_year`,
        `sales`.`customer_code` AS `customer_code`,
        `cus`.`customer` AS `customer`,
        `cus`.`market` AS `market`,
        `pro`.`product` AS `product`,
        `pro`.`variant` AS `variant`,
        `sales`.`sold_quantity` AS `sold_quantity`,
        `gross`.`gross_price` AS `gross_price`
    FROM
        (((`fact_sales_monthly` `sales`
        JOIN `dim_customer` `cus` ON ((`sales`.`customer_code` = `cus`.`customer_code`)))
        JOIN `dim_product` `pro` ON ((`pro`.`product_code` = `sales`.`product_code`)))
        JOIN `fact_gross_price` `gross` ON ((`pro`.`product_code` = `gross`.`product_code`)))

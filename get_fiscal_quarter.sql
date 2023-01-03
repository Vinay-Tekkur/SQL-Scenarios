CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_quarter`(calendar_date DATE) RETURNS varchar(10) CHARSET latin1
    DETERMINISTIC
BEGIN
DECLARE fiscal_month INT;
DECLARE fiscal_qurter VARCHAR(10);
SET fiscal_month = MONTH(calendar_date);
IF fiscal_month IN (9,10,11) THEN RETURN "Q1";
END IF;
IF fiscal_month IN (12,1,2) THEN RETURN "Q2";
END IF;
IF fiscal_month IN (3,4,5) THEN RETURN "Q3";
END IF;
IF fiscal_month IN (6,7,8) THEN RETURN "Q4";
END IF;
END

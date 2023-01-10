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



## Worst Performing contracts by industry in each country
SELECT  country,
	industry,
	ROUND(SUM(sales * 1000 )) as overall_total_sales,
	ROUND(SUM(profit * 1000)) as overall_total_profit,
	ROUND((SUM(profit * 1000)) / ROUND(SUM(sales * 1000 ))*100, 2) as profit_percentage
FROM aws_salesdata.`saas-sales`
Group BY country, industry
Having profit_percentage < 0
order by country, profit_percentage;

## Contracts that loses money for AWS by customers

SELECT  customer, industry,
	ROUND(SUM(sales * 1000 )) as overall_total_sales,
	ROUND(SUM(profit * 1000)) as overall_total_profit,
	ROUND((SUM(profit * 1000)) / ROUND(SUM(sales * 1000 ))*100, 2) as profit_percentage
FROM aws_salesdata.`saas-sales`
Group by customer, industry
HAVING overall_total_profit < 0
order by overall_total_profit;

## Calculating total sales and profit at each discount group

SELECT COUNT(customer) as number_of_customer, 
	discount,
	ROUND(AVG(sales * 1000 )) as avg_sales,
	ROUND(AVG(profit * 1000)) as avg_profit,
	ROUND((avg(profit * 1000)) / ROUND(avg(sales * 1000 ))*100, 2) as avg_profit_percentage
FROM aws_salesdata.`saas-sales`
GROUP BY discount
ORDER BY discount desc;


SELECT country, ROUND(SUM(sales * 1000 )) as overall_total_sales,
	ROUND(AVG(sales * 1000 )) as avg_sales,
    ROUND(SUM(profit * 1000)) as overall_total_profit,
	ROUND(AVG(profit * 1000)) as avg_profit,
    ROUND((SUM(profit * 1000)) / ROUND(SUM(sales * 1000 ))*100, 2) as profit_percentage
FROM aws_salesdata.`saas-sales`
Group BY country
ORDER by overall_total_profit desc, profit_percentage desc;

## Overall total profit and Overall total sale by country
SELECT country, 
	ROUND(SUM(sales * 1000 )) as overall_total_sales,
	ROUND(AVG(sales * 1000 )) as avg_sales,
    	ROUND(SUM(profit * 1000)) as overall_total_profit,
	ROUND(AVG(profit * 1000)) as avg_profit,
    	ROUND((SUM(profit * 1000)) / ROUND(SUM(sales * 1000 ))*100, 2) as profit_percentage
FROM aws_salesdata.`saas-sales`
Group BY country
ORDER by overall_total_profit desc, overall_total_sales desc;


## Finding the number of sales rep in the data set
SELECT COUNT(DISTINCT `Contact Name`) as num_salesrep
FROM aws_salesdata.`saas-sales`;

## Top 10 best performing sales rep based on profit generated
SELECT `Contact Name` as salesrep,
	ROUND(SUM(sales * 1000 )) as overall_total_sales,
	ROUND(AVG(sales * 1000 )) as avg_sales,
    ROUND(SUM(profit * 1000)) as overall_total_profit,
	ROUND(AVG(profit * 1000)) as avg_profit,
    ROUND((SUM(profit * 1000)) / ROUND(SUM(sales * 1000 ))*100, 2) as profit_percentage
FROM aws_salesdata.`saas-sales`
GROUP BY salesrep
ORDER BY overall_total_sales desc, avg_sales desc, profit_percentage desc
limit 10;

## Top performing sales representatives based on total sales generated:
SELECT `Contact Name` as salesrep,
	ROUND(SUM(sales * 1000 )) as overall_total_sales,
	ROUND(AVG(sales * 1000 )) as avg_sales,
    ROUND(SUM(profit * 1000)) as overall_total_profit,
	ROUND(AVG(profit * 1000)) as avg_profit,
    ROUND((SUM(profit * 1000)) / ROUND(SUM(sales * 1000 ))*100, 2) as profit_percentage
FROM aws_salesdata.`saas-sales`
GROUP BY salesrep
ORDER BY overall_total_sales desc, avg_sales desc, profit_percentage desc
limit 10;

## Top Performer in total sales "Diane Murray" had a net negative overall profit, avg profit and profit percentage.
## Investigate Diane Murrary's sales records.
	
SELECT `order date`, `Contact Name`, country, Customer, Industry,  quantity, discount,
	ROUND(sales * 1000) as dollar_sales,
    	ROUND(profit * 1000) as dollar_profit
FROM aws_salesdata.`saas-sales`
WHERE `Contact Name` = 'Diane Murray'
ORDER BY profit;

## Date clean up, changing the `Order Date` Column to date format "YYYY-MM-DD".

UPDATE`saas-sales`
SET `order date` = DATE_FORMAT(STR_TO_DATE(`order date`, '%m/%d/%Y'), '%Y-%m-%d');

## Total sales by each quarter of the year
SELECT
    YEAR(`Order Date`) AS `Year`,
    ROUND(SUM(CASE WHEN EXTRACT(QUARTER FROM `Order Date`) = 1 THEN sales * 1000 ELSE 0 END)) AS Quarter1,
    ROUND(SUM(CASE WHEN EXTRACT(QUARTER FROM `Order Date`) = 2 THEN sales * 1000 ELSE 0 END)) AS Quarter2,
    ROUND(SUM(CASE WHEN EXTRACT(QUARTER FROM `Order Date`) = 3 THEN sales * 1000 ELSE 0 END)) AS Quarter3,
    ROUND(SUM(CASE WHEN EXTRACT(QUARTER FROM `Order Date`) = 4 THEN sales * 1000 ELSE 0 END)) AS Quarter4
FROM
    aws_salesdata.`saas-sales`
GROUP BY
    Year(`Order Date`);

## Monthly sales of each year
SELECT year(`order date`) as year, `contact name`,
	ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 1 THEN sales * 1000 ELSE 0 END)) AS Jan,
	ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 2 THEN sales * 1000 ELSE 0 END)) AS Feb,
    ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 3 THEN sales * 1000 ELSE 0 END)) AS March,
    ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 4 THEN sales * 1000 ELSE 0 END)) AS April,
    ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 5 THEN sales * 1000 ELSE 0 END)) AS May,
    ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 6 THEN sales * 1000 ELSE 0 END)) AS June,
    ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 7 THEN sales * 1000 ELSE 0 END)) AS July,
    ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 8 THEN sales * 1000 ELSE 0 END)) AS August,
    ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 9 THEN sales * 1000 ELSE 0 END)) AS Sept,
    ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 10 THEN sales * 1000 ELSE 0 END)) AS Oct,
    ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 11 THEN sales * 1000 ELSE 0 END)) AS Nov,
    ROUND(SUM(CASE WHEN EXTRACT(Month FROM `Order Date`) = 12 THEN sales * 1000 ELSE 0 END)) AS Decem
FROM
    aws_salesdata.`saas-sales`
Group By 
	Year(`order date`), `contact name`
ORDER BY `contact name`, year(`order date`);


    

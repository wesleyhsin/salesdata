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


    

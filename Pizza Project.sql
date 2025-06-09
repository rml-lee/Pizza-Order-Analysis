# Pizza Place Sales Analysis


-- 1. What was the daily volume of orders for pizzas with mushrooms and tomatoes as toppings in January?
SELECT
    DAY(timestamp) AS day,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM
    orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    JOIN pizzas p
    ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
WHERE
      MONTH(timestamp) = 01
  AND ingredients LIKE '%Mushrooms%'
  AND ingredients LIKE '%Tomatoes%'
GROUP BY 1
ORDER BY 1 ASC;



-- 2. Which customers (order_id) ordered at least 3 different pizza types in a single order during the month of June?
SELECT
    o.order_id
FROM
    orders o
    JOIN order_details d
    ON o.order_id = d.order_id
    JOIN pizzas p
    ON d.pizza_id = p.pizza_id
WHERE
    MONTH(timestamp) = 06
GROUP BY 1
HAVING COUNT(DISTINCT pizza_type_id) >= 3
ORDER BY 1 ASC;



-- 3. What is the percentage of pizzas ordered of each size ('S', 'M', 'L', 'XL') across the entire year?
SELECT
    ROUND((SUM(IF(p.size = 'S', 1, 0)) / COUNT(*)) * 100, 0) AS small_percentage,
    ROUND((SUM(IF(p.size = 'M', 1, 0)) / COUNT(*)) * 100, 0) AS medium_percentage,
    ROUND((SUM(IF(p.size = 'L', 1, 0)) / COUNT(*)) * 100, 0) AS large_percentage,
    ROUND((SUM(IF(p.size = 'XL', 1, 0)) / COUNT(*)) * 100, 0) AS extra_large_percentage
FROM
    orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    JOIN pizzas p
    ON p.pizza_id = od.pizza_id;



-- 4. What is the quarterly revenue generated from each size of 'The Greek Pizza'?
SELECT
    QUARTER(timestamp) AS quarter,
    size,
    ROUND(SUM(quantity * price), 2) AS total_revenue
FROM
    orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    JOIN pizzas p
    ON p.pizza_id = od.pizza_id
WHERE
    pizza_type_id = 'the_greek'
GROUP BY 1, 2
ORDER BY 1 ASC, 2 ASC;



-- 5. Return a summary of revenue generated for every pizza type sold on July 6th.
SELECT
    pt.name,
    COALESCE(n_of_orders, 0) AS n_of_orders,
    COALESCE(r.total_revenue, 0) AS total_revenue
FROM
    (SELECT
         pizza_type_id,
         COUNT(DISTINCT o.order_id) AS n_of_orders,
         SUM(quantity * price) AS total_revenue
     FROM
         orders o
         JOIN order_details od
         ON o.order_id = od.order_id
         JOIN pizzas p
         ON p.pizza_id = od.pizza_id
     WHERE
         DATE(timestamp) = '2015-07-06'
     GROUP BY 1) r
    RIGHT JOIN pizza_types pt
    ON pt.pizza_type_id = r.pizza_type_id;



-- 6. Return the revenue and running total of revenue generated monthly from Chicken Alfredo Pizzas.
SELECT
    MONTH(o.timestamp) AS month,
    SUM(d.quantity * p.price) AS revenue,
    SUM(SUM(d.quantity * p.price)) OVER (ORDER BY DATE(o.timestamp) ASC) AS running_total
FROM
    order_details d
    JOIN pizzas p
    ON p.pizza_id = d.pizza_id
    JOIN orders o
    ON d.order_id = o.order_id
WHERE
      d.pizza_id LIKE '%alfredo%'
GROUP BY 1;



-- 7. What are the two busiest times of the day on average each week?
SELECT
    day_of_week,
    time_of_day,
    avg_total_orders
FROM
    (SELECT
         day_of_week,
         time_of_day,
         ROUND(AVG(total_orders), 0) AS avg_total_orders,
         DENSE_RANK() OVER (ORDER BY ROUND(AVG(total_orders), 0) DESC) AS rnk
     FROM
         (SELECT
              WEEK(timestamp) AS week,
              DAYNAME(timestamp) AS day_of_week,
              CASE
                  WHEN EXTRACT(HOUR FROM timestamp) < 12 THEN 'Morning'
                  WHEN EXTRACT(HOUR FROM timestamp) BETWEEN 12 AND 15 THEN 'Early Afternoon'
                  WHEN EXTRACT(HOUR FROM timestamp) > 15 THEN 'Late Afternoon'
              END AS time_of_day,
              COUNT(*) AS total_orders
          FROM
              orders
          GROUP BY 1, 2, 3) t
     GROUP BY 1, 2) t2
WHERE
    rnk <= 2;



-- 8. What is the revenue and percentage distribution for each pizza category?
SELECT
    category,
    ROUND(SUM(d.quantity * p.price), 2) AS revenue,
    ROUND((SUM(d.quantity * p.price) / r.total_revenue) * 100, 0) AS rev_percentage
FROM
    order_details d
    JOIN pizzas p
    ON d.pizza_id = p.pizza_id
    JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
    CROSS JOIN
            (SELECT
                 ROUND(SUM(d.quantity * p.price), 2) AS total_revenue
             FROM
                 order_details d
                 JOIN pizzas p
                 ON d.pizza_id = p.pizza_id
                 JOIN pizza_types pt
                 ON p.pizza_type_id = pt.pizza_type_id) r
GROUP BY 1;



-- 9. Compare the sales (in percentage) of pizzas on May 22 and June 22. Which pizzas had an increase in sales?

WITH main AS
    -- Gets records of orders that occurred during May 22 and June 22
         (SELECT
              timestamp,
              pizza_type_id,
              o.order_id,
              quantity,
              price
          FROM
              orders o
              JOIN order_details od
              ON o.order_id = od.order_id
              JOIN pizzas p
              ON p.pizza_id = od.pizza_id
          WHERE
              DATE(timestamp) IN ('2015-05-22', '2015-06-22')),

     may_revenue AS
         -- Returns revenue earned during May 22
         (SELECT
              pizza_type_id,
              ROUND(SUM(quantity * price), 2) AS may_rev
          FROM
              main
          WHERE
              MONTH(timestamp) = 05
          GROUP BY 1),

    jun_revenue AS
        -- Returns revenue earned during June 22
        (SELECT
            pizza_type_id,
            ROUND(SUM(quantity * price), 2) AS jun_rev
        FROM
            main
        WHERE
            MONTH(timestamp) = 06
        GROUP BY 1),

    summary AS
        -- Calculates the percentage variance in sales revenue
        (SELECT
            m.pizza_type_id,
            ROUND(((jun_rev - may_rev) / may_rev) * 100, 0) AS sales_variance
        FROM
            may_revenue m
            JOIN jun_revenue j
            ON j.pizza_type_id = m.pizza_type_id)

SELECT
    -- Returns the name of pizzas that showed an increase in sales revenue from May 22 to June 22
    pt.name,
    s.sales_variance
FROM
    summary s
    JOIN pizza_types pt
    ON pt.pizza_type_id = s.pizza_type_id
WHERE
    sales_variance > 0
ORDER BY 2 DESC;



-- 10. What are the order id's of orders that were made after 12pm on November 3rd?
WITH morn_orders AS
         (SELECT
              order_id,
              timestamp
          FROM
              orders
          WHERE
                DATE(timestamp) = '2015-11-03'
            AND EXTRACT(HOUR FROM timestamp) < 12)

SELECT
    o.order_id,
    o.timestamp AS post_morning_timestamp
FROM
    orders o
    LEFT JOIN morn_orders mo
    ON mo.timestamp = o.timestamp
WHERE
    DATE(o.timestamp) = '2015-11-03'
    AND mo.timestamp IS NULL;



-- 11. On November 3rd, how many orders did we receive in the morning? How many orders did we receive in the Afternoon & Evening?
WITH morn_orders AS
         (SELECT
              order_id,
              timestamp
          FROM
              orders
          WHERE
                DATE(timestamp) = '2015-11-03'
            AND EXTRACT(HOUR FROM timestamp) < 12)

SELECT
    CASE
        WHEN mo.timestamp IS NOT NULL THEN 'Morning'
        ELSE 'Afternoon/Evening'
    END AS time_of_day,
    COUNT(*) AS total_orders
FROM
    orders o
    LEFT JOIN morn_orders mo
    ON mo.timestamp = o.timestamp
WHERE
    DATE(o.timestamp) = '2015-11-03'
GROUP BY 1;
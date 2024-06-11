# Pizza Place Sales Analysis

# Data Cleaning

# Call Stored Procedure
CALL clean_data();

# -------------------------------------------------------------------------------------------------------------------

# Descriptive Statistics

# Date Range
SELECT DISTINCT
    DATE(timestamp) AS date_list
FROM
    orders;
-- Result: Covers the entire year of 2015


# List of Pizza Categories.
SELECT DISTINCT
    category
FROM
    pizza_types;

# ------------------------------------------------------------------------------------------------------------------

# Data Analysis

-- 1. What's the amount of orders received daily from pizzas that contained mushrooms and tomatoes as part of their toppings in January?
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
SELECT DISTINCT
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



-- 3. Return the pizza_id's of orders that contain 3 different pizza sizes.
SELECT
    pizza_id
FROM
    order_details
WHERE
    order_id IN
    (SELECT
         o.order_id
     FROM
         orders o
         JOIN order_details od
         ON o.order_id = od.order_id
         JOIN pizzas p
         ON p.pizza_id = od.pizza_id
     GROUP BY 1
     HAVING
         COUNT(DISTINCT size) = 3);



-- 4. What is the percentage of large pizzas ordered during December 13th?
SELECT
    (SUM(CASE
            WHEN p.size = 'L' THEN 1
            ELSE 0
        END) / COUNT(*)) * 100 AS percentage
FROM
    orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    JOIN pizzas p
    ON p.pizza_id = od.pizza_id
WHERE
    DATE(timestamp) = '2015-12-13';



-- 5. What is the quarterly revenue generated from each size of "The Greek Pizza"?
SELECT
    QUARTER(timestamp) AS quarter,
    size,
    ROUND(SUM(quantity * price), 0) AS total_revenue
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



-- 6. Return a summary of revenue generated for every pizza type sold on July 6th.
-- In case a certain pizza didn't sell, include it in the results as 0.
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



-- 7. List all order id's that occurred after 12pm on November 3rd using a CTE.
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



-- 8. On November 3rd, count the amount of orders that occurred in the morning and the amount during the Afternoon/Evening using a CTE.
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



-- 9. Which day has the highest average order volume per hour during the month of August?

WITH cte AS -- Returns the number of orders received per hour daily in Aug.
         (SELECT
              DATE(timestamp) AS day,
              HOUR(timestamp) AS hour,
              COUNT(DISTINCT o.order_id) AS total_orders
          FROM
              orders o
              JOIN order_details od
              ON o.order_id = od.order_id
          WHERE
              MONTH(timestamp) = 08
          GROUP BY 1, 2
          ORDER BY 1 ASC, 2 ASC),

     cte2 AS -- Returns the average amount of orders received daily
         (SELECT
              day,
              AVG(total_orders) AS avg_orders
          FROM
              cte
          GROUP BY 1)
SELECT -- Returns the the day we received the highest avg amount of pizza orders
    day,
    avg_orders
FROM
    cte2
WHERE
    avg_orders = (SELECT MAX(avg_orders) FROM cte2);



-- 10. Return the revenue and running total of revenue generated daily from Chicken Alfredo Pizzas during the month of February.
SELECT
    DATE(o.timestamp) AS day,
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
  AND MONTH(o.timestamp) = 02
GROUP BY 1;



-- 11. What are the top 2 busiest times of the week? (3rd week of Apr.)
SELECT
    day_of_week,
    time_of_day,
    total_orders
FROM
    (SELECT
         DAYNAME(timestamp) AS day_of_week,
         CASE
             WHEN EXTRACT(HOUR FROM timestamp) < 12 THEN 'Morning'
             WHEN EXTRACT(HOUR FROM timestamp) BETWEEN 12 AND 15 THEN 'Early Afternoon'
             WHEN EXTRACT(HOUR FROM timestamp) > 15 THEN 'Late Afternoon'
         END AS time_of_day,
         COUNT(DISTINCT o.order_id) AS total_orders,
         DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT o.order_id) DESC) AS rnk
     FROM
         orders o
         JOIN order_details od
         ON o.order_id = od.order_id
     WHERE
           MONTH(timestamp) = 04
       AND DAY(timestamp) BETWEEN 19 AND 25
     GROUP BY 1, 2) t
WHERE
    rnk <= 2;



-- 12. What is the revenue share percentage of each pizza category?
SELECT
    category,
    ROUND((SUM(d.quantity * p.price) / r.total_revenue) * 100, 0) AS rev_percentage
FROM
    order_details d
    JOIN pizzas p
    ON d.pizza_id = p.pizza_id
    JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
    CROSS JOIN
            (SELECT
                 ROUND(SUM(d.quantity * p.price), 0) AS total_revenue
             FROM
                 order_details d
                 JOIN pizzas p
                 ON d.pizza_id = p.pizza_id
                 JOIN pizza_types pt
                 ON p.pizza_type_id = pt.pizza_type_id) r
GROUP BY 1;




-- 13. Compare the sales (in percentage) of pizzas on May 22 and June 22. Which pizzas had an increase in sales from May to June?
WITH main AS
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
         (SELECT
              pizza_type_id,
              ROUND(SUM(quantity * price), 2) AS may_rev
          FROM
              main
          WHERE
              MONTH(timestamp) = 05
          GROUP BY 1),

    jun_revenue AS
        (SELECT
            pizza_type_id,
            ROUND(SUM(quantity * price), 2) AS jun_rev
        FROM
            main
        WHERE
            MONTH(timestamp) = 06
        GROUP BY 1),

    summary AS
        (SELECT
            m.pizza_type_id,
            ROUND(((jun_rev - may_rev) / may_rev) * 100, 0) AS sales_variance
        FROM
            may_revenue m
            JOIN jun_revenue j
            ON j.pizza_type_id = m.pizza_type_id)
SELECT
    name,
    sales_variance
FROM
    summary s
    JOIN pizza_types pt
    ON pt.pizza_type_id = s.pizza_type_id
WHERE
    sales_variance > 0;












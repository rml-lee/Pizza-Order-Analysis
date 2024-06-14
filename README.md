# MYSQL-Tableau-Pizza-Project

# Business Task

## Table of Contents
- [Orders Table](#orders-table)
- [Order Details Table](#order-details-table)
- [Pizzas Table](#pizzas-table)
- [Pizza Types Table](#pizza-types-table)

# Data Source

# Data Dictionary

## Orders Table

| Field     | Description                                                                              |
|-----------|------------------------------------------------------------------------------------------|
| order_id  | Unique identifier for each order placed by a table                                       |
| date      | Date the order was placed (entered into the system prior to cooking & serving)           |
| time      | Time the order was placed (entered into the system prior to cooking & serving)           |

## Order Details Table

| Field            | Description                                                                                      |
|------------------|--------------------------------------------------------------------------------------------------|
| order_details_id | Unique identifier for each pizza placed within each order (pizzas of the same type and size are kept in the same row, and the quantity increases) |
| order_id         | Foreign key that ties the details in each order to the order itself                              |
| pizza_id         | Foreign key that ties the pizza ordered to its details, like size and price                      |
| quantity         | Quantity ordered for each pizza of the same type and size                                        |

## Pizzas Table

| Field         | Description                                                                      |
|---------------|----------------------------------------------------------------------------------|
| pizza_id      | Unique identifier for each pizza (constituted by its type and size)              |
| pizza_type_id | Foreign key that ties each pizza to its broader pizza type                       |
| size          | Size of the pizza (Small, Medium, Large, X Large, or XX Large)                   |
| price         | Price of the pizza in USD                                                        |

## Pizza Types Table

| Field         | Description                                                                                              |
|---------------|----------------------------------------------------------------------------------------------------------|
| pizza_type_id | Unique identifier for each pizza type                                                                    |
| name          | Name of the pizza as shown in the menu                                                                   |
| category      | Category that the pizza falls under in the menu (Classic, Chicken, Supreme, or Veggie)                   |
| ingredients   | Comma-delimited ingredients used in the pizza as shown in the menu (they all include Mozzarella Cheese, even if not specified; and they all include Tomato Sauce, unless another sauce is specified) |


# Data Cleaning
Effective data analysis begins with ensuring the data is clean and well-structured. In this section, we outline the steps taken to clean the dataset, removing inconsistencies, correcting errors, and ensuring the integrity of the data.

To facilitate this process, i've have provided a SQL script that performs the necessary data cleaning operations. The script is a stored procedure. By running this script, the dataset is prepared for accurate and reliable analysis.

You can access the SQL file for data cleaning here.

# Data Schema
<img src="https://github.com/rml-lee/MYSQL-Tableau-Pizza-Project/assets/160198611/985c4eb2-6232-4f78-9690-3517af54f601" alt="Description" width="500"/>

# Data Analysis

# Summary/Findings

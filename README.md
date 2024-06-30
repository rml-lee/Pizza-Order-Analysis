# MYSQL-Tableau-Pizza-Project

# Business Task
The goal of this project is to gather actionable insights and identify trends from the provided dataset of a fictitious pizza place.

**Domain**: Food Service and Hospitality

## Table of Contents
- [Data Source](#data-source)
- [Data Dictionary](#data-dictionary)
- [Data Cleaning & Exploration](#data-cleaning--Exploration)
- [Data Schema](#data-schema)
- [Data Transformation](#data-transformation)
- [Analysis/Findings](#analysisfindings)

# Data Source
Pizza Place Sales - [Kaggle](https://www.kaggle.com/datasets/mysarahmadbhat/pizza-place-sales?select=order_details.csv)

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


# Data Cleaning & Exploration

Tools used:
| Python | Jupyter | Pandas | Numpy | Conda |
|--------|-------|---------|--------|-------|
| <img src="https://github.com/rml-lee/MYSQL-Tableau-Video-Games-Project/assets/160198611/cc008c2a-1e65-46fe-99aa-fcef90c84b2b" width="55" height="55"/> | <img src="https://github.com/rml-lee/MYSQL-Tableau-Video-Games-Project/assets/160198611/029ca083-0c94-40b2-96bc-5a4ccd5199bb" width="50" height="55"/> | <img src="https://github.com/rml-lee/MYSQL-Tableau-Video-Games-Project/assets/160198611/1f1bf784-7c28-491e-9c70-d78a8cfd9ec3" width="55" height="55"/> | <img src="https://github.com/rml-lee/MYSQL-Tableau-Video-Games-Project/assets/160198611/ca024f21-791d-4cc9-836a-710df995811a" width="55" height="55"/> | <img src="https://github.com/rml-lee/MYSQL-Tableau-Video-Games-Project/assets/160198611/752b8489-df2a-457b-ab2e-294b34774a78" width="55" height="55"/> |

In this section, you'll find a Jupyter Notebook that demonstrates my proficiency in data cleaning and exploration using pandas. This notebook showcases various techniques to clean and preprocess raw data, ensuring that it's ready for analysis.

You can access the Jupyter Notebook file [here](https://github.com/rml-lee/MYSQL-Tableau-Pizza-Project/blob/main/Data%20Cleaning%20%26%20Exploration%20-%20Pizza%20Project.ipynb).

# Data Schema

After cleaning the data, this is our schema that will be used throughout this project.

<img src="https://github.com/rml-lee/MYSQL-Tableau-Pizza-Project/assets/160198611/985c4eb2-6232-4f78-9690-3517af54f601" alt="Description" width="500"/>

# Data Transformation

Tools used:
| MySQL |
| ----- |
| <img src="https://github.com/rml-lee/MYSQL-Tableau-Video-Games-Project/assets/160198611/a1f80d2c-f675-4c97-b497-f21377fd0042" width="55" height="55"/> |

The provided SQL script contains a set of questions with queries used to gather insight about this dataset using MySQL. 

You can access the SQL file [here](https://github.com/rml-lee/MYSQL-Tableau-Pizza-Project/blob/main/Pizza%20Project.sql).

# Analysis/Findings

Tools used:
| Tableau |
| ------- |
| <img src="https://github.com/rml-lee/MYSQL-Tableau-Video-Games-Project/assets/160198611/fb9f12dc-8640-4197-b3f6-ab0ce2241bc1" width="55" height="55"/> |


To conclude, I've provided an analysis of the results from a few of the questions provided within the SQL file. This section will also include visuals for our data and discussing the implications and potential impact on the business or research problem at hand. The goal is to provide a thorough and actionable understanding of the data, guiding informed decision-making.

You can review the results [here](https://github.com/rml-lee/MYSQL-Tableau-Pizza-Project/blob/main/Summary-Findings.md#summaryfindings).

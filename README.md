# Food-Service-Database-Design
## **Overview**
This repository contains SQL scripts and documentation for creating and managing a database named FoodserviceDB. The database is designed to handle information on restaurants, consumers, and ratings, based on provided CSV files. The project includes creating the database, importing data, setting up relationships, and executing various queries and stored procedures.

## **Files**
README.md: This file.
FoodserviceDB.sql: SQL script for creating the database, importing data, setting up primary and foreign key constraints, and executing queries.
Restaurants.csv: Contains restaurant information.
Consumers.csv: Contains consumer information.
Ratings.csv: Contains rating information.
Restaurant_Cuisines.csv: Contains information on the cuisines served by each restaurant.
Database Creation and Setup

## **The SQL script performs the following tasks:**
-Creates the FoodserviceDB database.
-Imports data from the CSV files into the database.
-Adds primary and foreign key constraints to establish relationships between tables.
-Provides a database diagram showing the relationships between the tables.

## **Tables and Relationships**
Restaurant: Contains restaurant details.
Consumers: Contains consumer details.
Ratings: Contains ratings given by consumers to restaurants.
Primary Key: Composite key on Consumer_ID and Restaurant_ID.
Foreign Keys: References Consumers and Restaurant.
Restaurant_Cuisines: Contains information on the cuisines served by each restaurant.
Primary Key: Composite key on Restaurant_ID and Cuisine.
Foreign Key: References Restaurant.

## **How to Use**
1. Ensure you have SQL Server installed.
2. Create a new database using the FoodserviceDB.sql script.
3. Import data from the provided CSV files into the corresponding tables.
4. Execute the queries and stored procedures as needed.

### **Author**
Wisdom Adike

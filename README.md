# Netflix-movies
This Netflix Movies SQL Queries Repository is a collection of SQL scripts that can be used to analyze and manipulate data from a Netflix movie database.
The repository contains a variety of SQL queries that can be used to extract and analyze data such as the ranks of best shows and movies by year based on their genres, the role each character played, the average runtime of movies in different genres, movies suitable for different age groups and other related questions that can be used to gather insights. These scripts are written in SQL, which is a widely-used programming language for managing and querying databases, and the DBMS used is PostgreSQL.

# Installation of PostgreSQL 
PostgreSQL is an open-source relational database management system that is widely used for data storage and analysis.
Operating System Compatibility

1 Windows

2 Mac

3 Linux

**Prerequisites**
 
Before starting the installation process, make sure that you have the following software and tools installed:

PostgreSQL

pgAdmin (optional)

**Step-by-Step Guide**

The installation process for PostgreSQL consists of the following steps:

1 Download the PostgreSQL software from the official website.

2 Install the software following the instructions provided.

3 Open pgAdmin (if installed) and create a new database.

4 Configure the necessary settings for the database.

5 Verify that PostgreSQL is running correctly by accessing the database using pgAdmin or a terminal.

**Verification**

To verify that PostgreSQL has been installed correctly, you can do the following:

1 Open pgAdmin and connect to the newly created database.

2 Run a basic SQL query to check that the database is functioning correctly.

# Usage
To use this query, you need to have a database with these tables (best_movie_by_year, best_show_by_year, best_movies, best_shows, raw_credits, and raw_titles) and their data loaded into it.

Connect to the database: Establish a connection to the database where the 6 tables are stored. This can be done through pgAdmin.

Write the query: Write a SQL query. For example, you could write a query to get the movie titles, release years, and genres for all Netflix movies.

Execute the query: Run the query in your command line interface to execute it.

Review the results: Once the query has been executed, review the results to see if they match your expectations.

Here is an example of a query to get the first 10 rows of movie titles, release year, and genres for all Netflix:

SELECT *
FROM raw_titles
LIMIT 10;

The resulting data includes the first 10 rows of  movie titles, release years, and genres.

**Please note that the syntax of your query may vary depending on the database management system you are using.**

# Additional Resources
Find attached the link to the dataset used on kaggle
https://www.kaggle.com/datasets/heemalichaudhari/netflix-movies-and-series

**HAPPY EXPLORING 😁**

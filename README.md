# Introduction
Hi! This is my **PostgreSQL Portfolio Project**, which involves working with a business dataset of a cinema 
chain in Germany🎦.

At first, I designed and created tables in a database, so I can import the dataset 
from CSV files📅. The database stores data related to the cinemas, the screenings they host, and the 
managers responsible for each cinema. You can find a whole SQL file with a code that I wrote to create 
those tables in this folder: [creating_tables_sql](/creating_tables_sql/), I will also discuss it in the next section.  
The actual dataset itself could be found in this folder: [dataset_csv](/dataset_csv/).

After setting up database & tables and importing the dataset I wrote **SQL Queries**🔍 to answer 4
analytical & business questions. You can find all 4 SQL files with Queries to answer each of these 
question in this folder: [queries_sql](/queries_sql/).
And the results of these Queries in this folder: [results_csv](/results_csv/).

Let's get into it!

# Creating Tables to Import Dataset from csv files

As I already said, first step was designing and creating tables, so I can import dataset from CSV files.
As a result, three tables was created📅, one for storing information about all cinemas, second for keeping
screenings data and third for storing personal info of managers of these cinemas. Here are **SQL Queries**
I wrote to create those tables:

```
-- Creating table in database for storing Cinemas data

CREATE TABLE cinema (
    cinema_id SERIAL PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL UNIQUE,
    number_of_screens INT,
    seating_capacity INT NOT NULL,
    opening_date DATE NOT NULL,
    total_profit DECIMAL(15, 2),
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    manager_id INT REFERENCES Managers(manager_id)
);

-- Creating table for storing Screenings that are showing in cinemas

CREATE TABLE screening (
    screening_id SERIAL PRIMARY KEY,
    cinema_id INT REFERENCES Cinemas(cinema_id),
    movie_title VARCHAR(255) NOT NULL,
    screening_timestamp TIMESTAMP,
    screen_number INT,
    available_seats INT,
    total_seats INT,
    language VARCHAR(50),
    subtitle_language VARCHAR(50),
    ticket_price DECIMAL(10, 2) NOT NULL,
    rating VARCHAR(10) NOT NULL,
	length INT NOT NULL,
);

-- Creating table for storing managers personal info

CREATE TABLE manager (
    manager_id SERIAL PRIMARY KEY,
    manager_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    annual_salary DECIMAL(12, 2),
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    passport_details VARCHAR(50) NOT NULL UNIQUE
);
```
After that I imported data into these tables from Dataset CSV files that could be found in this folder: [dataset_csv](/dataset_csv/).  

# Writing SQL Queries to Answer Analytical Questions

Now, when everything is finally set up, It's time to actually write **SQL Queries** to analyze 📊 the data 
to answer 4 interesting analytical & business questions:

- What is the average revenue per rating for all cinemas❓
- What movies were shown in our cinemas within at least three different cities + the total revenue from those movies❓
- Which cinemas showed the Top 5 movie with the highest overall profits❓
- What length ranges of movies are the most profitable❓

Let's find out!

### 1. What is the average revenue per rating for all cinemas❓
To answer this question I wrote this **SQL Query**:

```
SELECT cinema.cinema_id, screening.rating,
	ROUND(AVG(screening.ticket_price * (screening.total_seats - screening.available_seats)), 2) 
	AS avg_revenue
FROM screening
JOIN cinema ON screening.cinema_id = cinema.cinema_id
GROUP BY  cinema.cinema_id, screening.rating
ORDER BY cinema.cinema_id, avg_revenue DESC;
```
The result of this Query:

| cinema_id | rating | avg_revenue |
|-----------|--------|-------------|
| 1         | R      | 378.13      |
| 1         | PG     | 200.00      |
| 1         | G      | 168.75      |
| 1         | PG-13  | 131.96      |
| 2         | PG     | 292.50      |
| 2         | PG-13  | 286.56      |
| 2         | R      | 222.50      |
| 2         | G      | 180.00      |
| 3         | PG     | 190.00      |
| 3         | R      | 162.50      |
| 3         | PG-13  | 159.58      |
| 4         | R      | 258.75      |
| 4         | PG-13  | 240.00      |
| 4         | PG     | 174.38      |
| 5         | R      | 298.13      |
| 5         | PG-13  | 240.31      |
| 5         | PG     | 202.50      |
| 6         | PG-13  | 265.45      |
| 6         | R      | 210.63      |
| 6         | PG     | 106.25      |
| 7         | R      | 275.63      |
| 7         | PG-13  | 247.50      |
| 7         | PG     | 180.00      |
| 8         | R      | 258.75      |
| 8         | PG-13  | 240.00      |
| 8         | PG     | 174.38      |
| 9         | R      | 275.63      |
| 9         | PG-13  | 247.50      |
| 9         | PG     | 185.63      |
| 10        | R      | 258.75      |
| 10        | PG-13  | 241.88      |
| 10        | PG     | 172.50      |

This Query is showing average revenue per rating for all cinemas. For example, from this query we can see that
the most profitable💸 rating for cinema with id 1 is 'R'! 

### 2. What movies were shown in our cinemas within at least three different cities + the total revenue from those movies❓
Here are **SQL Query** I wrote to answer this question:

```
SELECT screening.movie_title, 
SUM(
	CASE 
	WHEN screening.available_seats < screening.total_seats 
	THEN screening.ticket_price * (screening.total_seats - screening.available_seats) 
	ELSE 0 END) AS total_revenue
FROM screening
JOIN cinema ON screening.cinema_id = cinema.cinema_id
GROUP BY screening.movie_title
HAVING COUNT(DISTINCT cinema.city) > 3
ORDER BY total_revenue DESC;
```
The result of this Query:

| movie_title                                       | total_revenue |
|---------------------------------------------------|---------------|
| The Green Knight                                  | 3127.50       |
| Free Guy                                          | 2362.50       |
| Shang-Chi and the Legend of the Ten Rings         | 1840.00       |
| The Suicide Squad                                 | 1820.00       |
| Encanto                                           | 1360.00       |


This Query🔍 showing movies that were shown in our cinemas within at least three different cities 
and the total revenue from those films!

### 3. Which cinemas showed the Top 5 movie with the highest overall profits❓
To answer this question I wrote this **SQL Query**:

```
-- First part of the Query

WITH Top5Movies AS (
    SELECT movie_title, SUM(ticket_price * (total_seats - available_seats)) AS total_revenue
    FROM screening
    GROUP BY movie_title
    ORDER BY total_revenue DESC
    LIMIT 5
)

-- Second part of the Query

SELECT T.movie_title, STRING_AGG(DISTINCT S.cinema_id::TEXT, ', ') AS cinema_ids, 
SUM(S.ticket_price * (S.total_seats - S.available_seats)) AS total_revenue
FROM screening S
JOIN Top5Movies T ON S.movie_title = T.movie_title
GROUP BY T.movie_title
ORDER BY total_revenue DESC;
```
The result of this Query:

| movie_title                                    | cinema_ids             | total_revenue |
|------------------------------------------------|------------------------|---------------|
| The Green Knight                               | 10, 4, 6, 7, 8, 9      | 3127.50       |
| Free Guy                                       | 4, 6, 7, 8, 9          | 2362.50       |
| Shang-Chi and the Legend of the Ten Rings      | 3, 6, 7, 9             | 1840.00       |
| The Suicide Squad                              | 3, 6, 7, 9             | 1820.00       |
| The Matrix Resurrections                       | 1, 2, 5                | 1680.00       |

In the first part this query calculates Top 5 movies by total revenue from screenings within all cinemas.
In the second part it's grouping ids of cinemas that were showing these movies + the total revenue!

### 4. What length ranges of movies are the most profitable❓
**SQL Query** I wrote to answer this question:

```
SELECT
    CASE
        WHEN length BETWEEN 0 AND 90 THEN '0-90 minutes'
        WHEN length BETWEEN 91 AND 120 THEN '91-120 minutes'
        WHEN length BETWEEN 121 AND 150 THEN '121-150 minutes'
        WHEN length > 150 THEN '151+ minutes'
    END AS length_range,
    SUM((total_seats - available_seats) * ticket_price) AS total_revenue_per_range
FROM screening
GROUP BY length_range
ORDER BY total_revenue_per_range DESC;
```
The result of this Query:

| length_range       | total_revenue_per_range |
|--------------------|-------------------------|
| 91-120 minutes     | 13792.50                |
| 121-150 minutes    | 12077.50                |
| 151+ minutes       | 6026.00                 |
| 0-90 minutes       | 337.50                  |

This Query groups length of the movies into 4 range groups and showing total revenue per range,
as you can see 91-120 and 121-150 are the most profitable📈 length ranges within our cinemas!

All SQL files with these queries could be found in this folder: [queries_sql](/queries_sql/).  
All results of this queries exported in CSV files could be found here: [results_csv](/results_csv/).

# Conclusions

This **PostgreSQL** project showcases the process of designing & creating tables in database to import dataset from
CSV files. In result, 4 analytical & business questions were successfully answered✅

SQL file with a code that I wrote to create those tables in this folder: [creating_tables_sql](/creating_tables_sql/).  
The actual dataset could be found in this folder: [dataset_csv](/dataset_csv/).  
4 SQL files with Queries to answer each of these question in this folder: [queries_sql](/queries_sql/).  
The results of these Queries in this folder: [results_csv](/results_csv/).

_**Thank you for your attention!**_



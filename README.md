# Introduction
Hi! This is my **PostgreSQL Portfolio Project** that involves working with a business dataset of a cinema 
chain in Germany🎦 

At first, I designed and created a tables in a database, so I can import the dataset 
from CSV files📅. The database stores data related to the cinemas, the screenings they host, and the 
managers responsible for each cinema. You can find a whole SQL file with a code that I wrote to create 
those tables in this folder: [creating_tables_sql](/creating_tables_sql/), I will also discuss it in the next section.

After setting up database & tables and importing the dataset I wrote **SQL Queries**🔍 to answer 4
analytical & business questions. You can find all 4 SQL files with Queries to answer each of these 
question in this folder: [queries_sql](/queries_sql/).
And the results of these Queries in this folder: [results_csv](/results_csv/).

Let's get into it!

# Creating Tables to Import Dataset from csv files

As I already said, first step was designing and creating tables, so I can import dataset from CSV files.
As a result, three tables was created📅, one for storing information about all cinemas, second for keeping
screenings data and third for storing personal info of managers of these cinemas. Here is SQL Queries
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

That's it, and you also can this SQL file in this folder: [creating_tables_sql](/creating_tables_sql/).

# Writing SQL Queries to Answer Analytical Questions



# Conclusions
✅
fdsfds
- **SQL**
- fsd
- fs

[link](//)
📊
📅
🔍
❓
🎦

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
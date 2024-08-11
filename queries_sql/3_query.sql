-- In the first part this query calculates Top 5 movies by total revenue from screenings within all cinemas
-- In the second part this query grouping ids of cinemas that were showing these movies + the total revenue

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

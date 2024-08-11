-- This Query showing movies that where shown in our cinemas within at least three different cities 
-- and the total revenue from those films

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

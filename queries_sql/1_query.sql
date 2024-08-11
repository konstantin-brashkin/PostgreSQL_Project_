-- This Query is showing average revenue per rating for all cinemas. For example, from this query we can see that
-- the most profitable rating for cinema with id 1 is 'R'! 

SELECT cinema.cinema_id, screening.rating,
	ROUND(AVG(screening.ticket_price * (screening.total_seats - screening.available_seats)), 2) AS avg_revenue
FROM screening
JOIN cinema ON screening.cinema_id = cinema.cinema_id
GROUP BY  cinema.cinema_id, screening.rating
ORDER BY cinema.cinema_id, avg_revenue DESC;
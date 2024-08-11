-- This Query groups length of the movies into 4 range groups and showing total revenue per range,
-- as you can see 91-120 and 121-150 are the most profitable length ranges within our cinemas

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

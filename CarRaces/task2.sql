SELECT
    c.name,
    cl.class,
    ROUND(AVG(r.position), 4) AS average_position,
    COUNT(r.race) AS race_count,
    cl.country AS car_country
FROM
    Results r
        JOIN
    Cars c ON r.car = c.name
        JOIN
    Classes cl ON c.class = cl.class
GROUP BY
    c.name, cl.class, cl.country
ORDER BY
    average_position ASC, c.name ASC
LIMIT 1;
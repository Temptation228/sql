WITH CarAvgPositions AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM Cars AS c
             JOIN Results AS r
                  ON c.name = r.car
    GROUP BY
        c.name,
        c.class
), ClassAvgPositions AS (
    SELECT
        car_class,
        AVG(avg_position) AS class_avg_position
    FROM CarAvgPositions
    GROUP BY
        car_class
    HAVING
        COUNT(*) > 1
)
SELECT
    cp.car_name,
    cp.car_class,
    ROUND(cp.avg_position, 4) AS average_position,
    cp.race_count,
    cl.country AS car_country
FROM CarAvgPositions AS cp
         JOIN ClassAvgPositions AS cap
              ON cp.car_class = cap.car_class
         JOIN Classes AS cl
              ON cp.car_class = cl.class
WHERE
    cp.avg_position < cap.class_avg_position
ORDER BY
    cp.car_class,
    cp.avg_position;
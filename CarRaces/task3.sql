WITH ClassAvgPositions AS (
    SELECT
        c.class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS class_race_count
    FROM
        Cars c
            JOIN
        Results r ON c.name = r.car
    GROUP BY
        c.class
),
     MinAvgPosition AS (
         SELECT
             MIN(avg_position) AS min_avg_position
         FROM
             ClassAvgPositions
     ),
     BestClasses AS (
         SELECT
             cap.class,
             cap.class_race_count
         FROM
             ClassAvgPositions cap
                 JOIN
             MinAvgPosition map ON cap.avg_position = map.min_avg_position
     ),
     CarAverages AS (
         SELECT
             c.name AS car_name,
             c.class AS car_class,
             AVG(r.position) AS average_position,
             COUNT(r.race) AS race_count
         FROM
             Cars c
                 JOIN
             Results r ON c.name = r.car
         GROUP BY
             c.name, c.class
     )
SELECT
    ca.car_name,
    ca.car_class,
    ROUND(ca.average_position, 4) AS average_position,
    ca.race_count,
    cl.country AS car_country,
    bc.class_race_count AS total_races
FROM
    CarAverages ca
        JOIN
    Classes cl ON ca.car_class = cl.class
        JOIN
    BestClasses bc ON ca.car_class = bc.class
ORDER BY
    average_position, car_name;
WITH CarAvgPositions AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Cars AS c
             JOIN Results AS r
                  ON c.name = r.car
    GROUP BY
        c.name,
        c.class
),
     LowAvgCars AS (
         SELECT
             cap.car_name,
             cap.car_class,
             cap.average_position,
             cap.race_count
         FROM CarAvgPositions AS cap
         WHERE
             cap.average_position > 3.0
     ),
     ClassRaceCounts AS (
         SELECT
             c.class AS car_class,
             COUNT(r.race) AS total_races
         FROM Cars AS c
                  JOIN Results AS r
                       ON c.name = r.car
         GROUP BY
             c.class
     ),
     ClassLowAvgCounts AS (
         SELECT
             lpc.car_class,
             COUNT(lpc.car_name) AS low_position_count
         FROM LowAvgCars AS lpc
         GROUP BY
             lpc.car_class
     )
SELECT
    lpc.car_name,
    lpc.car_class,
    ROUND(lpc.average_position, 4) AS average_position,
    lpc.race_count,
    cl.country AS car_country,
    crc.total_races,
    clac.low_position_count
FROM LowAvgCars AS lpc
         JOIN Classes AS cl
              ON lpc.car_class = cl.class
         JOIN ClassRaceCounts AS crc
              ON lpc.car_class = crc.car_class
         LEFT JOIN ClassLowAvgCounts AS clac
                   ON lpc.car_class = clac.car_class
ORDER BY
    clac.low_position_count DESC,
    lpc.average_position DESC;
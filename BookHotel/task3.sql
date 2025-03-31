WITH HotelCategories AS (
    SELECT
        ID_hotel,
        CASE
            WHEN AVG(price) < 175 THEN 'Дешевый'
            WHEN AVG(price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
            END AS category
    FROM
        Room
    GROUP BY
        ID_hotel
),
     CustomerPreferences AS (
         SELECT
             c.ID_customer,
             c.name,
             CASE
                 WHEN EXISTS (
                     SELECT 1
                     FROM Booking b
                              JOIN Room r ON b.ID_room = r.ID_room
                              JOIN HotelCategories hc ON r.ID_hotel = hc.ID_hotel
                     WHERE b.ID_customer = c.ID_customer AND hc.category = 'Дорогой'
                 ) THEN 'Дорогой'
                 WHEN EXISTS (
                     SELECT 1
                     FROM Booking b
                              JOIN Room r ON b.ID_room = r.ID_room
                              JOIN HotelCategories hc ON r.ID_hotel = hc.ID_hotel
                     WHERE b.ID_customer = c.ID_customer AND hc.category = 'Средний'
                 ) THEN 'Средний'
                 ELSE 'Дешевый'
                 END AS preferred_hotel_type,
             (
                 SELECT
                     STRING_AGG(DISTINCT h.name, ', ')
                 FROM
                     Booking b
                         JOIN
                     Room r ON b.ID_room = r.ID_room
                         JOIN
                     Hotel h ON r.ID_hotel = h.ID_hotel
                 WHERE b.ID_customer = c.ID_customer
             )AS visited_hotels
         FROM
             Customer c
     )
SELECT
    ID_customer,
    name,
    preferred_hotel_type,
    visited_hotels
FROM
    CustomerPreferences
ORDER BY
    CASE
        WHEN preferred_hotel_type = 'Дешевый' THEN 1
        WHEN preferred_hotel_type = 'Средний' THEN 2
        ELSE 3
        END;
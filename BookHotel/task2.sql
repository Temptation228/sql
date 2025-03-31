SELECT
    c.ID_customer,
    c.name,
    COUNT(DISTINCT b.ID_booking) AS total_bookings,
    SUM(r.price) AS total_spent,
    COUNT(DISTINCT h.ID_hotel) AS unique_hotels
FROM
    Customer c
        JOIN
    Booking b ON c.ID_customer = b.ID_customer
        JOIN
    Room r ON b.ID_room = r.ID_room
        JOIN
    Hotel h ON r.ID_hotel = h.ID_hotel
WHERE c.ID_customer IN (SELECT
                            c.ID_customer
                        FROM
                            Customer c
                                JOIN
                            Booking b ON c.ID_customer = b.ID_customer
                                JOIN
                            Room r ON b.ID_room = r.ID_room
                                JOIN
                            Hotel h ON r.ID_hotel = h.ID_hotel
                        GROUP BY
                            c.ID_customer
                        HAVING
                            COUNT(DISTINCT h.ID_hotel) > 1 AND COUNT(DISTINCT b.ID_booking) > 2) AND c.ID_customer IN (SELECT
                                                                                                                           c.ID_customer
                                                                                                                       FROM
                                                                                                                           Customer c
                                                                                                                               JOIN
                                                                                                                           Booking b ON c.ID_customer = b.ID_customer
                                                                                                                               JOIN
                                                                                                                           Room r ON b.ID_room = r.ID_room
                                                                                                                       GROUP BY
                                                                                                                           c.ID_customer
                                                                                                                       HAVING
                                                                                                                           SUM(r.price) > 500)
GROUP BY
    c.ID_customer, c.name
ORDER BY
    total_spent ASC;
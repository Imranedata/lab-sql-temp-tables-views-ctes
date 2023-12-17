USE sakila;

CREATE VIEW rental_summary AS 
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    sakila.customer c
    LEFT JOIN sakila.rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id, customer_name, c.email;
    

CREATE TEMPORARY TABLE payment_summary AS
SELECT
    r.customer_id,
    SUM(p.amount) AS total_paid
FROM
    sakila.rental r
    JOIN sakila.payment p ON r.rental_id = p.rental_id
GROUP BY
    r.customer_id;
    

WITH customer_summary_cte AS (
    SELECT
        rs.customer_id,
        rs.customer_name,
        rs.email,
        rs.rental_count,
        ps.total_paid
    FROM
        rental_summary rs
        JOIN payment_summary ps ON rs.customer_id = ps.customer_id
)


SELECT
    csc.customer_name,
    csc.email,
    csc.rental_count,
    csc.total_paid,
    CASE
        WHEN csc.rental_count > 0 THEN csc.total_paid / csc.rental_count
        ELSE 0
    END AS average_payment_per_rental
FROM
    customer_summary_cte csc;





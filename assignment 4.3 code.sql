WITH CustomerSpending AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        ci.city AS city,
        SUM(p.amount) AS total_spent,
        COUNT(r.rental_id) AS rental_count
    FROM 
        customer c
    JOIN 
        payment p ON c.customer_id = p.customer_id
    JOIN 
        rental r ON p.rental_id = r.rental_id
    JOIN 
        address a ON c.address_id = a.address_id
    JOIN 
        city ci ON a.city_id = ci.city_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, ci.city
)
SELECT 
    customer_id,
    customer_name,
    city,
    total_spent,
    rental_count,
    DENSE_RANK() OVER (PARTITION BY city ORDER BY total_spent DESC) AS city_spending_rank,
    ROUND(total_spent / SUM(total_spent) OVER (PARTITION BY city) * 100, 2) AS percentage_of_city_total,
    ROUND(total_spent / rental_count, 2) AS avg_spend_per_rental
FROM 
    CustomerSpending
ORDER BY 
    city, city_spending_rank;
WITH CustomerPayments AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(p.amount) AS total_payments
    FROM 
        customer c
    JOIN 
        payment p ON c.customer_id = p.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name
),
AveragePayment AS (
    SELECT AVG(total_payments) AS avg_payment
    FROM CustomerPayments
)
SELECT 
    customer_id,
    customer_name,
    total_payments AS total_spent,
    (SELECT avg_payment FROM AveragePayment) AS average_customer_spending,
    (total_payments - (SELECT avg_payment FROM AveragePayment)) AS amount_above_average
FROM 
    CustomerPayments
WHERE 
    total_payments > (SELECT avg_payment FROM AveragePayment)
ORDER BY 
    total_payments DESC;
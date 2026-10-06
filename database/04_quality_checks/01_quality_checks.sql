SET search_path TO sda_retail;

-- Contrôles de qualité simples à utiliser par les apprenants.

SELECT 'customers_without_email' AS check_name, COUNT(*) AS issue_count
FROM customers WHERE email IS NULL OR TRIM(email)='';

SELECT 'orders_without_customer' AS check_name, COUNT(*) AS issue_count
FROM orders o LEFT JOIN customers c ON c.customer_id=o.customer_id
WHERE c.customer_id IS NULL;

SELECT 'order_items_without_product' AS check_name, COUNT(*) AS issue_count
FROM order_items oi LEFT JOIN products p ON p.product_id=oi.product_id
WHERE p.product_id IS NULL;

SELECT 'negative_sales_lines' AS check_name, COUNT(*) AS issue_count
FROM v_order_line_sales WHERE line_revenue < 0;

SELECT 'inventory_below_reorder_level' AS check_name, COUNT(*) AS issue_count
FROM inventory WHERE stock_quantity < reorder_level;

SELECT 'completed_orders_without_payment' AS check_name, COUNT(*) AS issue_count
FROM orders o
WHERE o.order_status='Completed'
  AND NOT EXISTS (SELECT 1 FROM payments p WHERE p.order_id=o.order_id AND p.payment_status='Paid');

-- Contrôle d'unicité des emails
SELECT email, COUNT(*) AS occurrences
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

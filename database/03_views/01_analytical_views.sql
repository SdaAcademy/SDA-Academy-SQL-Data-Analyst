SET search_path TO sda_retail;

CREATE OR REPLACE VIEW v_order_line_sales AS
SELECT
    o.order_id,
    o.order_date::date AS order_date,
    o.customer_id,
    o.store_id,
    o.channel,
    o.order_status,
    oi.order_item_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.discount_amount,
    ROUND((oi.quantity * oi.unit_price) - oi.discount_amount,2) AS line_revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id;

CREATE OR REPLACE VIEW v_monthly_sales AS
SELECT
    DATE_TRUNC('month', order_date)::date AS month,
    SUM(line_revenue) FILTER (WHERE order_status = 'Completed') AS revenue,
    COUNT(DISTINCT order_id) FILTER (WHERE order_status = 'Completed') AS orders,
    SUM(quantity) FILTER (WHERE order_status = 'Completed') AS units
FROM v_order_line_sales
GROUP BY 1
ORDER BY 1;

CREATE OR REPLACE VIEW v_customer_sales AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.segment,
    c.city,
    COUNT(DISTINCT s.order_id) FILTER (WHERE s.order_status='Completed') AS completed_orders,
    COALESCE(SUM(s.line_revenue) FILTER (WHERE s.order_status='Completed'),0) AS revenue
FROM customers c
LEFT JOIN v_order_line_sales s ON s.customer_id=c.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name,c.segment,c.city;

CREATE OR REPLACE VIEW v_product_sales AS
SELECT
    p.product_id,
    p.product_name,
    cat.category_name,
    p.brand,
    COALESCE(SUM(s.quantity) FILTER (WHERE s.order_status='Completed'),0) AS units_sold,
    COALESCE(SUM(s.line_revenue) FILTER (WHERE s.order_status='Completed'),0) AS revenue
FROM products p
JOIN categories cat ON cat.category_id=p.category_id
LEFT JOIN v_order_line_sales s ON s.product_id=p.product_id
GROUP BY p.product_id,p.product_name,cat.category_name,p.brand;

CREATE OR REPLACE VIEW v_campaign_performance AS
SELECT
    c.campaign_id,
    c.campaign_name,
    c.channel,
    c.budget_usd,
    COUNT(*) FILTER (WHERE ce.event_type='Impression') AS impressions,
    COUNT(*) FILTER (WHERE ce.event_type='Click') AS clicks,
    COUNT(*) FILTER (WHERE ce.event_type='Lead') AS leads,
    COUNT(*) FILTER (WHERE ce.event_type='Conversion') AS conversions,
    COALESCE(SUM(ce.revenue_usd),0) AS attributed_revenue,
    ROUND(COALESCE(SUM(ce.revenue_usd),0)/NULLIF(c.budget_usd,0),2) AS roas
FROM campaigns c
LEFT JOIN campaign_events ce ON ce.campaign_id=c.campaign_id
GROUP BY c.campaign_id,c.campaign_name,c.channel,c.budget_usd;

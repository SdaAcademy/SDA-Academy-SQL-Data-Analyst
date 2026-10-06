-- SDA Academy / SDA Retail
-- PostgreSQL
-- Schéma pédagogique principal

DROP SCHEMA IF EXISTS sda_retail CASCADE;
CREATE SCHEMA sda_retail;
SET search_path TO sda_retail;

CREATE TABLE customers (
    customer_id      BIGSERIAL PRIMARY KEY,
    first_name       VARCHAR(80) NOT NULL,
    last_name        VARCHAR(80) NOT NULL,
    email            VARCHAR(180) UNIQUE NOT NULL,
    gender           VARCHAR(20),
    birth_date       DATE,
    city             VARCHAR(100),
    province         VARCHAR(100),
    segment          VARCHAR(30) NOT NULL CHECK (segment IN ('Retail','Premium','Corporate')),
    signup_date      DATE NOT NULL,
    status           VARCHAR(20) NOT NULL DEFAULT 'Active'
                     CHECK (status IN ('Active','Inactive','Blocked'))
);

CREATE TABLE stores (
    store_id         BIGSERIAL PRIMARY KEY,
    store_name       VARCHAR(120) NOT NULL,
    city             VARCHAR(100) NOT NULL,
    province         VARCHAR(100) NOT NULL,
    store_type       VARCHAR(30) NOT NULL CHECK (store_type IN ('Mall','Street','Online','Wholesale')),
    opening_date     DATE NOT NULL
);

CREATE TABLE employees (
    employee_id      BIGSERIAL PRIMARY KEY,
    first_name       VARCHAR(80) NOT NULL,
    last_name        VARCHAR(80) NOT NULL,
    department       VARCHAR(80) NOT NULL,
    job_title        VARCHAR(100) NOT NULL,
    store_id         BIGINT REFERENCES stores(store_id),
    hire_date        DATE NOT NULL,
    salary_usd       NUMERIC(12,2) CHECK (salary_usd > 0),
    status           VARCHAR(20) NOT NULL CHECK (status IN ('Active','Inactive'))
);

CREATE TABLE categories (
    category_id      BIGSERIAL PRIMARY KEY,
    category_name    VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE products (
    product_id       BIGSERIAL PRIMARY KEY,
    category_id      BIGINT NOT NULL REFERENCES categories(category_id),
    sku              VARCHAR(50) UNIQUE NOT NULL,
    product_name     VARCHAR(150) NOT NULL,
    brand            VARCHAR(100) NOT NULL,
    unit_cost        NUMERIC(12,2) NOT NULL CHECK (unit_cost >= 0),
    unit_price       NUMERIC(12,2) NOT NULL CHECK (unit_price >= unit_cost),
    launch_date      DATE,
    active           BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE orders (
    order_id         BIGSERIAL PRIMARY KEY,
    customer_id      BIGINT NOT NULL REFERENCES customers(customer_id),
    store_id         BIGINT REFERENCES stores(store_id),
    employee_id      BIGINT REFERENCES employees(employee_id),
    order_date       TIMESTAMP NOT NULL,
    channel          VARCHAR(30) NOT NULL CHECK (channel IN ('Store','Online','Wholesale')),
    order_status     VARCHAR(30) NOT NULL CHECK (order_status IN ('Completed','Cancelled','Returned','Pending')),
    discount_amount  NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0)
);

CREATE TABLE order_items (
    order_item_id    BIGSERIAL PRIMARY KEY,
    order_id         BIGINT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id       BIGINT NOT NULL REFERENCES products(product_id),
    quantity         INTEGER NOT NULL CHECK (quantity > 0),
    unit_price       NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    discount_amount  NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0)
);

CREATE TABLE payments (
    payment_id       BIGSERIAL PRIMARY KEY,
    order_id         BIGINT NOT NULL REFERENCES orders(order_id),
    payment_date     TIMESTAMP NOT NULL,
    payment_method   VARCHAR(30) NOT NULL CHECK (payment_method IN ('Cash','Card','Mobile Money','Bank Transfer')),
    amount           NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    payment_status   VARCHAR(20) NOT NULL CHECK (payment_status IN ('Paid','Failed','Refunded','Pending'))
);

CREATE TABLE campaigns (
    campaign_id      BIGSERIAL PRIMARY KEY,
    campaign_name    VARCHAR(150) NOT NULL,
    channel          VARCHAR(50) NOT NULL,
    start_date       DATE NOT NULL,
    end_date         DATE NOT NULL,
    budget_usd       NUMERIC(12,2) NOT NULL CHECK (budget_usd >= 0),
    CHECK (end_date >= start_date)
);

CREATE TABLE campaign_events (
    event_id         BIGSERIAL PRIMARY KEY,
    campaign_id      BIGINT NOT NULL REFERENCES campaigns(campaign_id),
    customer_id      BIGINT REFERENCES customers(customer_id),
    event_date       TIMESTAMP NOT NULL,
    event_type       VARCHAR(30) NOT NULL CHECK (event_type IN ('Impression','Click','Lead','Conversion')),
    revenue_usd      NUMERIC(12,2) NOT NULL DEFAULT 0
);

CREATE TABLE inventory (
    inventory_id     BIGSERIAL PRIMARY KEY,
    store_id         BIGINT NOT NULL REFERENCES stores(store_id),
    product_id       BIGINT NOT NULL REFERENCES products(product_id),
    snapshot_date    DATE NOT NULL,
    stock_quantity   INTEGER NOT NULL CHECK (stock_quantity >= 0),
    reorder_level    INTEGER NOT NULL CHECK (reorder_level >= 0),
    UNIQUE(store_id, product_id, snapshot_date)
);

CREATE TABLE returns (
    return_id        BIGSERIAL PRIMARY KEY,
    order_item_id    BIGINT NOT NULL REFERENCES order_items(order_item_id),
    return_date      DATE NOT NULL,
    quantity         INTEGER NOT NULL CHECK (quantity > 0),
    reason           VARCHAR(100) NOT NULL,
    refund_amount    NUMERIC(12,2) NOT NULL CHECK (refund_amount >= 0)
);

CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_campaign_events_campaign ON campaign_events(campaign_id);
CREATE INDEX idx_inventory_product_date ON inventory(product_id, snapshot_date);

COMMENT ON SCHEMA sda_retail IS 'SDA Academy pedagogical retail analytics database';

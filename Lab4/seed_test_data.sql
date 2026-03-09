BEGIN;

TRUNCATE TABLE
  public.product_price_change,
  public.purchase_item,
  public.purchase,
  public.product,
  public.customer,
  public.store,
  public.category,
  public.manufacturer
RESTART IDENTITY CASCADE;

-- =====================
-- manufacturer (>=300)
-- =====================
INSERT INTO public.manufacturer (manufacturer_id, manufacturer_name)
SELECT
  7000 + series_id,
  'Manufacturer ' || series_id
FROM generate_series(1, 300) AS series_id;

-- ==================
-- category (>=100)
-- ==================
INSERT INTO public.category (category_id, category_name)
SELECT
  65000 + series_id,
  'Category ' || series_id
FROM generate_series(1, 100) AS series_id;

-- ==========
-- store (30)
-- ==========
INSERT INTO public.store (store_id, store_name, store_addr)
SELECT
  2000 + series_id,
  'Store ' || series_id,
  'City ' || series_id || ', Street ' || series_id
FROM generate_series(1, 30) AS series_id;

-- ==================
-- customer (>=300)
-- ==================
INSERT INTO public.customer (customer_id, customer_addr, last_name, first_name, patronymic)
SELECT
  10000 + series_id,
  'Address ' || series_id,
  'LastName ' || series_id,
  'FirstName ' || series_id,
  CASE
    WHEN series_id % 5 = 0 THEN NULL
    ELSE 'Patronymic ' || series_id
  END
FROM generate_series(1, 300) AS series_id;

-- ==================
-- product (>=1000)
-- ==================
INSERT INTO public.product
  (product_id, product_name, category_id, manufacturer_id, product_color, product_size)
SELECT
  50000 + series_id,
  'Product ' || series_id,
  65000 + ((series_id - 1) % 100) + 1,
  7000 + ((series_id - 1) % 300) + 1,
  CASE series_id % 5
    WHEN 0 THEN 'Black'
    WHEN 1 THEN 'White'
    WHEN 2 THEN 'Gray'
    WHEN 3 THEN 'Blue'
    ELSE 'Red'
  END,
  CASE
    WHEN series_id % 3 = 0 THEN (20 + (series_id % 30)) || ' cm'
    ELSE NULL
  END
FROM generate_series(1, 1000) AS series_id;

-- ===================
-- purchase (>=100000)
-- ===================
INSERT INTO public.purchase
  (purchase_id, store_id, customer_id, purchase_date, delivery_date, discount)
SELECT
  900000 + series_id,
  2000 + ((series_id - 1) % 30) + 1,
  10000 + ((series_id - 1) % 300) + 1,
  DATE '2024-01-01' + ((series_id - 1) % 365),
  DATE '2024-01-01' + ((series_id - 1) % 365) + ((series_id - 1) % 7) + 1,
  ((series_id % 15) * 0.01)::numeric(6, 4)
FROM generate_series(1, 100000) AS series_id;

-- =========================
-- purchase_item (>=100000)
-- =========================
INSERT INTO public.purchase_item (purchase_id, product_id, product_count, product_price)
SELECT
  900000 + series_id,
  50000 + ((series_id - 1) % 1000) + 1,
  ((series_id - 1) % 5) + 1,
  (100 + (series_id % 900))::numeric(12, 2)
FROM generate_series(1, 100000) AS series_id;

-- ============================
-- product_price_change (>=100000)
-- ============================
INSERT INTO public.product_price_change (store_id, product_id, date_price_change, new_price)
SELECT
  2000 + ((series_id - 1) % 30) + 1,
  50000 + ((series_id - 1) % 1000) + 1,
  TIMESTAMP '2024-01-01 00:00:00' + (series_id - 1) * INTERVAL '1 second',
  (500 + (series_id % 4500))::numeric(12, 2)
FROM generate_series(1, 100000) AS series_id;

COMMIT;

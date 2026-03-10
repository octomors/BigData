-- 9) Самая дорогая и самая дешевая покупка (по сумме позиций до скидки).
WITH totals AS (
  SELECT
    p.purchase_id,
    p.purchase_date,
    p.delivery_date,
    p.customer_id,
    p.store_id,
    SUM(pi.product_count * pi.product_price) AS total_before_discount
  FROM purchase p
  JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
  GROUP BY p.purchase_id, p.purchase_date, p.delivery_date, p.customer_id, p.store_id
),
ranked AS (
  SELECT
    t.*,
    RANK() OVER (ORDER BY total_before_discount DESC) AS r_desc,
    RANK() OVER (ORDER BY total_before_discount ASC)  AS r_asc
  FROM totals t
)
SELECT
  CASE
    WHEN r_desc = 1 THEN 'most_expensive'
    WHEN r_asc  = 1 THEN 'cheapest'
  END AS purchase_rank,
  purchase_id,
  store_id,
  customer_id,
  purchase_date,
  delivery_date,
  total_before_discount
FROM ranked
WHERE r_desc = 1 OR r_asc = 1
ORDER BY total_before_discount DESC, purchase_id;
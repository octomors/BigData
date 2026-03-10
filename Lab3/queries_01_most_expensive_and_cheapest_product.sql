-- 1) Самый дорогой и самый дешевый товар (по текущей зафиксированной цене в product_price_change)
-- Если у товара несколько изменений цены, берем последнюю по дате.
WITH latest_price AS (
  SELECT
    ppc.product_id,
    ppc.new_price,
    ROW_NUMBER() OVER (PARTITION BY ppc.product_id ORDER BY ppc.date_price_change DESC) AS rn
  FROM product_price_change ppc
),
priced AS (
  SELECT
    pr.product_id,
    pr.product_name,
    lp.new_price
  FROM product pr
  JOIN latest_price lp
    ON lp.product_id = pr.product_id
   AND lp.rn = 1
),
ranked AS (
  SELECT
    priced.*,
    RANK() OVER (ORDER BY new_price DESC) AS r_desc,
    RANK() OVER (ORDER BY new_price ASC)  AS r_asc
  FROM priced
)
SELECT
  CASE
    WHEN r_desc = 1 THEN 'most_expensive'
    WHEN r_asc  = 1 THEN 'cheapest'
  END AS price_rank,
  product_id,
  product_name,
  new_price
FROM ranked
WHERE r_desc = 1 OR r_asc = 1
ORDER BY new_price DESC, product_name;
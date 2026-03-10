-- 4) Топ-3 продуктов с самыми длинными наименованиями,
-- затем отсортировать их в алфавитном порядке.
WITH top3 AS (
  SELECT
    p.product_id,
    p.product_name,
    LENGTH(p.product_name) AS name_len
  FROM product p
  ORDER BY name_len DESC, p.product_name
  LIMIT 3
)
SELECT
  product_id,
  product_name,
  name_len
FROM top3
ORDER BY name_len;
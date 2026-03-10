-- 12) Покупатели, которые купили более 10 товаров с марта текущего года.
-- "С марта текущего года" = с 1 марта текущего года.
WITH since_march AS (
  SELECT
    p.customer_id,
    SUM(pi.product_count) AS items_bought
  FROM purchase p
  JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
  WHERE p.purchase_date >= make_date(EXTRACT(YEAR FROM CURRENT_DATE)::int, 3, 1)
  GROUP BY p.customer_id
)
SELECT
  c.customer_id,
  c.last_name,
  c.first_name,
  c.patronymic,
  sm.items_bought
FROM since_march sm
JOIN customer c ON c.customer_id = sm.customer_id
WHERE sm.items_bought > 10
ORDER BY sm.items_bought DESC, c.last_name, c.first_name, c.patronymic;
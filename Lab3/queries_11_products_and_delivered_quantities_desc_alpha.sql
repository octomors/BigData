-- 11) Товары и в каком количестве их доставляли,
-- отсортировать товары в обратном алфавитному порядку.
-- "доставляли" - наличие delivery_date (не NULL).
SELECT
  pr.product_id,
  pr.product_name,
  SUM(pi.product_count) AS delivered_qty
FROM purchase p
JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
JOIN product pr ON pr.product_id = pi.product_id
WHERE p.delivery_date IS NOT NULL
GROUP BY pr.product_id, pr.product_name
ORDER BY pr.product_name DESC;
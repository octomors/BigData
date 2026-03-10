-- 2) Количество товаров, которое было доставлено с 5 мая 2021 по текущий день.
-- "Количество товаров" - сумма product_count по доставленным покупкам.
SELECT
  COALESCE(SUM(pi.product_count), 0) AS delivered_items_count
FROM purchase p
JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
WHERE p.delivery_date >= DATE '2021-05-05'
  AND p.delivery_date <= CURRENT_DATE;
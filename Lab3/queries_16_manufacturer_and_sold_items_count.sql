-- 16) Производитель и количество проданных товаров данного производителя.
-- "Количество проданных товаров" = сумма product_count по позициям, где product принадлежит производителю.
SELECT
  m.manufacturer_id,
  m.manufacturer_name,
  COALESCE(SUM(pi.product_count), 0) AS sold_items_count
FROM manufacturer m
LEFT JOIN product pr ON pr.manufacturer_id = m.manufacturer_id
LEFT JOIN purchase_item pi ON pi.product_id = pr.product_id
GROUP BY m.manufacturer_id, m.manufacturer_name
ORDER BY sold_items_count DESC, m.manufacturer_name;
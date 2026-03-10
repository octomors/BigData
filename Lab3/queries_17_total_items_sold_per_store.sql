-- 17) Суммарное количество товаров, проданных с каждого филиала.
SELECT
  s.store_id,
  s.store_name,
  s.store_addr,
  COALESCE(SUM(pi.product_count), 0) AS sold_items_count
FROM store s
LEFT JOIN purchase p ON p.store_id = s.store_id
LEFT JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
GROUP BY s.store_id, s.store_name, s.store_addr
ORDER BY sold_items_count DESC, s.store_name;
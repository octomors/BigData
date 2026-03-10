SELECT DISTINCT
  s.store_id,
  s.store_addr,
  m.manufacturer_name
FROM store s
JOIN purchase pch ON s.store_id = pch.store_id
JOIN purchase_item pi ON pch.purchase_id = pi.purchase_id
JOIN product pr ON pi.product_id = pr.product_id
JOIN manufacturer m ON pr.manufacturer_id = m.manufacturer_id
WHERE m.manufacturer_name = 'Samsung'
ORDER BY s.store_addr;
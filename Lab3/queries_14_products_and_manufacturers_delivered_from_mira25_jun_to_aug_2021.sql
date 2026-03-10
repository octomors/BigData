-- 14) Наименование товара и его производителя, доставка которого осуществилась
-- с филиала «Мира 25» с июня 2021 по август 2021.
SELECT DISTINCT
  pr.product_name,
  m.manufacturer_name,
  p.purchase_id,
  p.delivery_date
FROM purchase p
JOIN store s ON s.store_id = p.store_id
JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
JOIN product pr ON pr.product_id = pi.product_id
JOIN manufacturer m ON m.manufacturer_id = pr.manufacturer_id
WHERE (s.store_name ILIKE '%Мира 25%' OR s.store_addr ILIKE '%Мира 25%')
  AND p.delivery_date >= DATE '2021-06-01'
  AND p.delivery_date <  DATE '2021-09-01'
ORDER BY p.delivery_date, pr.product_name;
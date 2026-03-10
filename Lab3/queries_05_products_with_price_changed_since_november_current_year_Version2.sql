-- 5) Наименования товаров, цена которых изменилась с ноября текущего года.
SELECT DISTINCT
  p.product_id,
  p.product_name
FROM product_price_change ppc
JOIN product p ON p.product_id = ppc.product_id
WHERE ppc.date_price_change >= make_timestamp(EXTRACT(YEAR FROM CURRENT_DATE)::int, 11, 1, 0, 0, 0)
ORDER BY p.product_name;
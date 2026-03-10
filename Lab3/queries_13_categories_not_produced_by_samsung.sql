-- 13) Категории товаров, которые не производит компания Samsung.
SELECT
  c.category_id,
  c.category_name
FROM category c
WHERE c.category_id NOT IN (
  SELECT DISTINCT p.category_id
  FROM product p
  WHERE p.manufacturer_id IN (
    SELECT m.manufacturer_id
    FROM manufacturer m
    WHERE m.manufacturer_name = 'Samsung'
  )
)
ORDER BY c.category_name;
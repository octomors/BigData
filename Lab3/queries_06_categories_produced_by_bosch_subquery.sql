-- 6) Категории товаров, которые производит компания Bosh/Bosch (подзапрос).
-- Используем manufacturer_name ILIKE, чтобы поймать "Bosch" и возможное "Bosh".
SELECT
  c.category_id,
  c.category_name
FROM category c
WHERE c.category_id IN (
  SELECT DISTINCT p.category_id
  FROM product p
  WHERE p.manufacturer_id IN (
    SELECT m.manufacturer_id
    FROM manufacturer m
    WHERE m.manufacturer_name ILIKE 'b%sch'
       OR m.manufacturer_name ILIKE 'bosh'
  )
)
ORDER BY c.category_name;
-- 3) Производители: начинаются на A, 3-я буква 'O', последняя 'M'.
SELECT
  m.manufacturer_id,
  m.manufacturer_name
FROM manufacturer m
WHERE UPPER(m.manufacturer_name) LIKE 'A_O%M'
ORDER BY m.manufacturer_name;
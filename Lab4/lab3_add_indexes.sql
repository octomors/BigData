BEGIN;

-- Индексы для ускорения запросов из Lab3.
-- Для ILIKE-поиска по подстроке (Query 06, 14) требуется pg_trgm.
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Query 01: быстро находим последнюю цену по каждому товару.
CREATE INDEX IF NOT EXISTS product_price_change_product_date_idx
  ON public.product_price_change (product_id, date_price_change DESC);

-- Query 05: фильтрация изменений цены по дате.
CREATE INDEX IF NOT EXISTS product_price_change_date_product_idx
  ON public.product_price_change (date_price_change, product_id);

-- Query 02, 11, 14: фильтр по delivery_date.
CREATE INDEX IF NOT EXISTS purchase_delivery_date_idx
  ON public.purchase (delivery_date);

-- Query 12: покупки с марта текущего года по клиенту.
CREATE INDEX IF NOT EXISTS purchase_purchase_date_customer_idx
  ON public.purchase (purchase_date, customer_id);

-- Query 07, 17: соединения по store_id.
CREATE INDEX IF NOT EXISTS purchase_store_id_idx
  ON public.purchase (store_id);

-- Query 09, 17: соединения purchase_item по purchase_id.
CREATE INDEX IF NOT EXISTS purchase_item_purchase_id_idx
  ON public.purchase_item (purchase_id);

-- Query 07, 11, 15, 16: соединения purchase_item по product_id.
CREATE INDEX IF NOT EXISTS purchase_item_product_id_idx
  ON public.purchase_item (product_id);

-- Query 06, 07, 13, 16: соединения товаров по manufacturer_id/category_id.
CREATE INDEX IF NOT EXISTS product_manufacturer_category_idx
  ON public.product (manufacturer_id, category_id);

-- Query 03: поиск по UPPER(manufacturer_name).
CREATE INDEX IF NOT EXISTS manufacturer_name_upper_idx
  ON public.manufacturer (UPPER(manufacturer_name));

-- Query 06, 07, 13: поиск производителя по ILIKE/равенству.
CREATE INDEX IF NOT EXISTS manufacturer_name_trgm_idx
  ON public.manufacturer USING gin (manufacturer_name gin_trgm_ops);

-- Query 04: топ самых длинных названий товаров.
CREATE INDEX IF NOT EXISTS product_name_length_idx
  ON public.product ((LENGTH(product_name)) DESC, product_name);

-- Query 08: поиск максимальной длины фамилии.
CREATE INDEX IF NOT EXISTS customer_last_name_length_idx
  ON public.customer ((LENGTH(last_name)) DESC);

-- Query 10: группировка покупателей по имени.
CREATE INDEX IF NOT EXISTS customer_first_name_idx
  ON public.customer (first_name);

-- Query 14: поиск филиала по подстроке в названии/адресе.
CREATE INDEX IF NOT EXISTS store_name_trgm_idx
  ON public.store USING gin (store_name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS store_addr_trgm_idx
  ON public.store USING gin (store_addr gin_trgm_ops);

COMMIT;

BEGIN;

-- Индексы для ускорения запросов из Lab3.
CREATE INDEX IF NOT EXISTS product_price_change_product_date_idx
  ON public.product_price_change (product_id, date_price_change DESC);

CREATE INDEX IF NOT EXISTS purchase_delivery_date_idx
  ON public.purchase (delivery_date);

CREATE INDEX IF NOT EXISTS purchase_purchase_date_customer_idx
  ON public.purchase (purchase_date, customer_id);

CREATE INDEX IF NOT EXISTS purchase_store_id_idx
  ON public.purchase (store_id);

CREATE INDEX IF NOT EXISTS purchase_item_purchase_id_idx
  ON public.purchase_item (purchase_id);

CREATE INDEX IF NOT EXISTS purchase_item_product_id_idx
  ON public.purchase_item (product_id);

CREATE INDEX IF NOT EXISTS product_manufacturer_category_idx
  ON public.product (manufacturer_id, category_id);

CREATE INDEX IF NOT EXISTS manufacturer_name_upper_idx
  ON public.manufacturer (UPPER(manufacturer_name));

CREATE INDEX IF NOT EXISTS customer_first_name_idx
  ON public.customer (first_name);

COMMIT;

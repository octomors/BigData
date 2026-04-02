import pandas as pd
from faker import Faker
import random
from datetime import datetime, timedelta

fake = Faker('ru_RU')

rows = []

for i in range(1000):
    rows.append({
        "manufacturer_name": random.choice(["HP", "Dell", "Lenovo"]),
        "date_price_change": fake.date_between(start_date='-2y', end_date='today'),
        "store_addr": fake.address(),
        "customer_id": random.randint(1, 100),
        "purchase_date": fake.date_between(start_date='-1y', end_date='today'),
        "product_count": random.randint(1, 5),
        "product_name": random.choice(["Ноутбук", "Телефон", "Планшет"]),
        "category_name": random.choice(["Компьютеры", "Электроника"]),
        "store_id": random.randint(1000, 2000),
        "purchase_id": i,
        "category_id": random.randint(1, 10),
        "product_price": round(random.uniform(10000, 100000), 2),
        "customer_addr": fake.address(),
        "product_color": random.choice(["Черный", "Белый", "Серый"]),
        "manufacturer_id": random.randint(1, 50),
        "new_price": round(random.uniform(10000, 100000), 2),
        "store_name": fake.company(),
        "product_size": random.randint(1, 10),
        "product_id": random.randint(1000, 5000),
        "delivery_date": fake.date_between(start_date='-1y', end_date='today'),
        "customer_name": fake.name(),
        "discount": random.choice(["0%", "10%", "15%"])
    })

df = pd.DataFrame(rows)

df.to_parquet("data.parquet")

print("Файл создан")
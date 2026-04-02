import pandas as pd
import boto3
import psycopg2
from io import BytesIO

# MinIO
s3 = boto3.client(
    's3',
    endpoint_url='http://localhost:9000',
    aws_access_key_id='admin',
    aws_secret_access_key='password123'
)

obj = s3.get_object(Bucket='dwh-bucket', Key='data.parquet')
df = pd.read_parquet(BytesIO(obj['Body'].read()))

# PostgreSQL
conn = psycopg2.connect(
    dbname="dwh",
    user="postgres",
    password="your_password",
    host="localhost"
)

cur = conn.cursor()

for _, row in df.iterrows():
    cur.execute("""
        INSERT INTO raw.sales_raw VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, tuple(row))

conn.commit()
cur.close()
conn.close()

print("Загружено в RAW")
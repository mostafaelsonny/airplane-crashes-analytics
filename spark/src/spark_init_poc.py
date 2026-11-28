import os
import sys

os.environ["PYSPARK_PYTHON"] = sys.executable
os.environ["PYSPARK_DRIVER_PYTHON"] = sys.executable

from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("AirplaneCrashes-SparkPoC") \
    .master("local[*]") \
    .getOrCreate()

df = spark.createDataFrame(
    [("Boeing", 10), ("Airbus", 5)],
    ["aircraft", "fatalities"]
)
df.show()
spark.stop() 
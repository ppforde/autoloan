df = spark.read.csv("/home/gda/loans.csv", header=True, inferSchema=True)

df.columns

df.dtypes

df.printSchema()

df.show()

df.groupBy("TERM").agg({"MONTHLY":"sum"}).orderBy("TERM").show()

df.groupBy("TERM").pivot("LOAN").agg({"MONTHLY":"sum"}).orderBy("TERM").show()



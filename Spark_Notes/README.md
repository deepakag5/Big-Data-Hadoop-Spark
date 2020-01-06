## Spark Driver/Executor

Spark Applications consist of a driver process and a set of executor processes. The driver process runs your main() function, sits on a node in the cluster, and is responsible for three things: 
1. maintaining information about the Spark Application; 
2. responding to a user’s program or input; 
3. analyzing, distributing, and scheduling work across the executors 

The driver process is absolutely essential—it’s the heart of a Spark Application and maintains all relevant information during the lifetime of the application.

The executors are responsible for actually carrying out the work that the driver assigns them. This means that each executor is responsible for only two things: 
1. executing code assigned to it by the driver, and 
2. reporting the state of the computation on that executor back to the driver node

## The SparkSession

The first step of any Spark Application is creating a SparkSession. In many interactive modes, this is done for you, but in an application, you must do it manually.

// Creating a SparkSession in Scala
import org.apache.spark.sql.SparkSession
val spark = SparkSession.builder().appName("Databricks Spark Example").config("spark.sql.warehouse.dir", "/user/hive/warehouse").getOrCreate()

**Creating a SparkSession in Python**

from pyspark.sql import SparkSession
spark = SparkSession.builder.master("local").appName("Word Count")\.config("spark.some.config.option", "some-value")\.getOrCreate()



##The SparkConf

The SparkConf manages all of our application configurations. You create one via the import
statement, as shown in the example that follows. After you create it, the SparkConf is immutable for that specific Spark Application:

// in Scala

import org.apache.spark.SparkConf
val conf = new SparkConf().setMaster("local[2]").setAppName("DefinitiveGuide")
.set("some.conf", "to.some.value")

// in Python

from pyspark import SparkConf
conf = SparkConf().setMaster("local[2]").setAppName("DefinitiveGuide")\
.set("some.conf", "to.some.value")

spark.conf.set("spark.sql.shuffle.partitions", 50)
spark.conf.set(“spark.executor.memory”, “2g”)



## Partitions

To allow every executor to perform work in parallel, Spark breaks up the data into chunks called
partitions. A partition is a collection of rows that sit on one physical machine in your cluster. A
DataFrame’s partitions represent how the data is physically distributed across the cluster of machines during execution. If you have one partition, Spark will have a parallelism of only one, even if you have thousands of executors. If you have many partitions but only one executor, Spark will still have a parallelism of only one because there is only one computation resource

spark.conf.set("spark.sql.shuffle.partitions", "5")


## Transformations

In Spark, the core data structures are immutable, meaning they cannot be changed after they’re
created. This might seem like a strange concept at first: if you cannot change it, how are you supposed to use it? To “change” a DataFrame, you need to instruct Spark how you would like to modify it to do what you want. These instructions are called transformations.

Narrow vs Wide Transformation

Transformations consisting of narrow dependencies (we’ll call them narrow transformations) are
those for which each input partition will contribute to only one output partition. 

A wide dependency (or wide transformation) style transformation will have input partitions
contributing to many output partitions. You will often hear this referred to as a shuffle whereby Spark will exchange partitions across the cluster. 

With narrow transformations, Spark will automatically perform an operation called pipelining, meaning that if we specify multiple filters on DataFrames, they’ll all be performed in-memory. The same cannot be said for shuffles. When we perform a shuffle, Spark writes the results to disk.


/* DATA LOADING */
CREATE OR REPLACE EXTERNAL TABLE `carbide-bongo-413214.mage_demo_dataset.green_taxi_trip`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://mage-demo-carbide-bongo-413214-terra-bucket/green_taxi_data_2022/green_tripdata_2022-*.parquet']
);

/*Q1 A : 840,402  */
SELECT COUNT(*) FROM `carbide-bongo-413214.mage_demo_dataset.green_taxi_trip`;


/*Q2 A : 0 MB for the External Table and 6.41MB for the Materialized Table  */


CREATE OR REPLACE TABLE `carbide-bongo-413214.mage_demo_dataset.mat_green_taxi_trip`
AS 
SELECT * 
FROM `carbide-bongo-413214.mage_demo_dataset.green_taxi_trip`;

6.41 MB
SELECT COUNT(DISTINCT (PULocationID))
FROM `carbide-bongo-413214.mage_demo_dataset.green_taxi_trip`;

6.41 MB
SELECT COUNT(DISTINCT (PULocationID))
FROM `carbide-bongo-413214.mage_demo_dataset.mat_green_taxi_trip`;


/*Q3 A : 1,622  */
SELECT COUNT(*)
FROM `carbide-bongo-413214.mage_demo_dataset.green_taxi_trip`
WHERE fare_amount = 0;


/*Q4 
What is the best strategy to make an optimized table in Big Query if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime? (Create a new table with this strategy)

A :Partition by lpep_pickup_datetime Cluster on PUlocationID  */



/*Q5 A : 12.82 MB for non-partitioned table and 1.12 MB for the partitioned table */
CREATE OR REPLACE TABLE `carbide-bongo-413214.mage_demo_dataset.partition_green_taxi_trip`
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS (
  SELECT * FROM `carbide-bongo-413214.mage_demo_dataset.mat_green_taxi_trip`
);


/* non-partitioned table */
SELECT COUNT(DISTINCT (PULocationID))
FROM `carbide-bongo-413214.mage_demo_dataset.mat_green_taxi_trip`
WHERE lpep_pickup_datetime >= '2022-06-01' AND lpep_pickup_datetime <= '2022-06-30';

/* partitioned table */
SELECT COUNT(DISTINCT (PULocationID))
FROM `carbide-bongo-413214.mage_demo_dataset.partition_green_taxi_trip`
WHERE lpep_pickup_datetime >= '2022-06-01' AND lpep_pickup_datetime <= '2022-06-30';

/*Q6 Where is the data stored in the External Table you created?
A : GCP Bucket */


/*Q7 It is best practice in Big Query to always cluster your data:
A : False */
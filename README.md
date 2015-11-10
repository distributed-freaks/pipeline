# Pipeline Description

Genmics data → ADAM/Spark → Parquet → Aggregation-DF/Spark → Cassandra → Scala Service → Curl/Notebook-client

# Instructions
## Git
Make sure my local clone is up to date

```
git pull
```

# Docker image
Get the docker image from the docker hub:

```
docker pull xtordoir/pipeline
```

## Run image
Running the image and optionally mounting the cloned notebooks directory in the docker image:

```
docker run -it -m 8g -p 30080:80 -p 34040:4040 -p 34041:4041 -p 39160:9160 -p 39042:9042 -p 39200:9200 -p 37077:7077 -p 36060:6060 -p 36061:6061 -p 32181:2181 -p 38090:8090 -p 38099:8099 -p 30000:10000 -p 30070:50070 -p 30090:50090 -p 39092:9092 -p 36066:6066 -p 39000:9000 -p 39999:19999 -p 36081:6081 -p 35601:5601 -p 37979:7979 -p 38989:8989 xtordoir/pipeline bash
```

If you want to save the notebooks, you can ask docker to mount the local folder from the git clone.

```
docker run -it -m 8g -v `pwd`/notebooks:/root/pipeline/notebooks -p 30080:80 -p 34040:4040 -p 34041:4041 -p 39160:9160 -p 39042:9042 -p 39200:9200 -p 37077:7077 -p 36060:6060 -p 36061:6061 -p 32181:2181 -p 38090:8090 -p 38099:8099 -p 30000:10000 -p 30070:50070 -p 30090:50090 -p 39092:9092 -p 36066:6066 -p 39000:9000 -p 39999:19999 -p 36081:6081 -p 35601:5601 -p 37979:7979 -p 38989:8989 xtordoir/pipeline bash
```

## Setup

From now on we are inside the docker instance.

We setup the services

```
cd pipeline
```

The following script will init the services and will create schemas among other things.

```
source devoxx-setup.sh
```

## Start
After a little time, all services should be up, e.g. cassandra

```
source config/bash/.profile
```

Try starting the cassandra shell for instance:

```
cqlsh
```

# Spark Notebook
The spark Notebook is available in the browser

```
http://<localhost or docker ip>:39000
```

## Notebooks
Notebooks for this project are in the `pipeline` folder, where you'll find:
* `AdamToDataframe.snb` that takes genomics data read them using ADAM, shape then save them as parquet
* `AggregateAndSaveToCassandra.snb` that reads parquet file, computes stats and store data in Cassandra

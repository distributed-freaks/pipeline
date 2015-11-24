# Pipeline Description

Genomics data → ADAM/Spark → Parquet → Aggregation-DF/Spark → Cassandra → Scala Service → Curl/Notebook-client

<!-- MarkdownTOC -->

- [Instructions][instructions]
  - [Git][git]
- [Docker image][docker-image]
  - [Run image][run-image]
- [Setup][setup]
- [Use][use]
  - [Cassandra][cassandra]
  - [Spark Notebook][spark-notebook]
  - [Run the full pipeline][run-the-full-pipeline]

<!-- /MarkdownTOC -->

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

# Setup

From now on we are inside the docker instance.

We setup the services

```
cd pipeline
```

The following script will init the services and will create schemas among other things.

```
source devoxx-setup.sh
```

# Use
After a little time, all services should be up, e.g. cassandra

```
source config/bash/.profile
```

### Cassandra
Try starting the cassandra shell for instance:

```
cqlsh $IP_eth0
```

### Spark Notebook
The spark Notebook is available in the browser

```
http://<localhost or docker ip>:39000
```


## Run the full pipeline

> **FIRST**: Be sure you've entered the pipeline folder and executed `source config/bash/.profile` !!!

The order of operations are the following:
Open the spark notebook on [http://<localhost or docker ip>:39000](http://<localhost or docker ip>:39000).

Enter the `pipeline` folder.

1. Click on **AdamToDataframe**. Read the comments and run each cell through the end. This example pre-process some genomics data
2. On the Main page of the spark notebook, click on the **Running** Tab and shutdown the running notebook (to save your resources)
3. Click open the **AggregateAndSaveToCassandra**, again run it all. This is computing stats and saving them in Cassandra.
4. Again, shutdown the notebook in the **Running** tab on the main page.
5. In the **terminal**, `cd rest-api && sed -i s/\$\{IP_eth0\}/${IP_eth0}/ src/main/resources/application.conf && sbt run`. This is starting the REST service in Akka HTTP reading data from Cassandra and serving them in JSON.
6. Open the **Rest Call** notebook and execute it. This one uses Akka HTTP (client now) to access the REST service and plot some data.
7. Open the **Rest Call (using HTML form)** notebook. It's essentially the same as above but present the REST calls in an HTML form instead of query parameter in a `String`.

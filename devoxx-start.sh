#!/bin/bash

echo ...Starting SSH...
service ssh start

#echo ...Starting Apache2 Httpd...
# service apache2 start

#echo ...Starting MySQL...
#service mysql start

echo ...Starting Cassandra...
nohup cassandra

#echo ...Starting ZooKeeper...
#nohup zookeeper-server-start $PIPELINE_HOME/config/kafka/zookeeper.properties &

#echo ...Starting Kafka...
#nohup kafka-server-start $PIPELINE_HOME/config/kafka/server.properties &

echo ...Starting Spark Master...
nohup $SPARK_HOME/sbin/start-master.sh --webui-port 6060 -i 127.0.0.1 -h 127.0.0.1

echo ...Starting Spark Worker...
nohup $SPARK_HOME/sbin/start-slave.sh --webui-port 6061 spark://127.0.0.1:7077

#echo ...Starting Apache Spark JDBC ODBC Hive ThriftServer...
## MySql must be started - and the password set - before ThriftServer will startup
## Starting the ThriftServer will create a dummy derby.log and metastore_db per https://github.com/apache/spark/pull/6314
## The actual Hive metastore defined in conf/hive-site.xml is still used, however.
#nohup $SPARK_HOME/sbin/start-thriftserver.sh --jars $MYSQL_CONNECTOR_JAR --master spark://127.0.0.1:7077

echo ...Starting Spark Notebook...
screen  -m -d -S "snb" bash -c 'source ~/pipeline/config/bash/.profile && spark-notebook -Dconfig.file=$PIPELINE_HOME/config/spark-notebook/application-pipeline.conf >> nohup.out'

#echo ...Starting Spark History Server...
#$SPARK_HOME/sbin/start-history-server.sh

#echo ...Starting Kafka Schema Registry...
## Starting this at the end due to race conditions with other kafka components
#nohup schema-registry-start $PIPELINE_HOME/config/schema-registry/schema-registry.properties &

#echo ...Starting Kafka REST Proxy...
#nohup kafka-rest-start $PIPELINE_HOME/config/kafka-rest/kafka-rest.properties &

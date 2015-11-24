# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f /root/.bashrc ]; then
    . /root/.bashrc
  fi
fi

mesg n

# IP address eth0
export IP_eth0=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

# Dev Install
export DEV_INSTALL_HOME=/root

# Pipeline Home
export PIPELINE_HOME=$DEV_INSTALL_HOME/pipeline

###################################################################
# The following DATA_HOME and LOGS_HOME are not always used by apps
# due to limitations with certain apps and how they resolve exports

# In these cases, the configs are usually relative to where the
# service is started
#   ie. LOGS_DIR=logs/kafka, DATA_DIR=data/zookeeper, etc

# If these paths change, be sure to grep and update the hard coded
# versions in all apps including the .tgz packages if their
# configs are not aleady exposed under pipeline/config/...

# Java Home
export JAVA_HOME=/usr

# MySQL
export MYSQL_CONNECTOR_JAR=/usr/share/java/mysql-connector-java.jar
###################################################################

# Cassandra
export CASSANDRA_HOME=$DEV_INSTALL_HOME/apache-cassandra-2.2.0
export PATH=$PATH:$CASSANDRA_HOME/bin

# Spark
export SPARK_HOME=$DEV_INSTALL_HOME/spark-1.4.1-bin-fluxcapacitor
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export SPARK_EXAMPLES_JAR=$SPARK_HOME/lib/spark-examples-1.4.1-hadoop2.6.0.jar

# Kafka
export KAFKA_HOME=$DEV_INSTALL_HOME/confluent-1.0
export PATH=$PATH:$KAFKA_HOME/bin

# ZooKeeper
export ZOOKEEPER_HOME=$KAFKA_HOME/bin
export PATH=$PATH:$ZOOKEEPER_HOME/bin

# SBT
export SBT_HOME=$DEV_INSTALL_HOME/sbt
export PATH=$PATH:$SBT_HOME/bin
export SBT_OPTS="-Xmx10G -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=2G"

# Spark Notebook
export SPARK_NOTEBOOK_HOME=$DEV_INSTALL_HOME/spark-notebook-0.6.2-SNAPSHOT-scala-2.10.4-spark-1.4.1-hadoop-2.6.0-with-hive-with-parquet
export PATH=$PATH:$SPARK_NOTEBOOK_HOME/bin

# Spark JobServer
export SPARK_JOBSERVER_HOME=$DEV_INSTALL_HOME/spark-jobserver-0.5.2

FROM ubuntu:14.04

ENV SCALA_VERSION 2.10.4
ENV SPARK_VERSION 1.4.1

EXPOSE 80 4042 9160 9042 9200 7077 38080 38081 6060 6061 8090 8099 10000 50070 50090 9092 6066 9000 19999 6379 6081 7474 8787 5601 8989 7979 4040

RUN \
 apt-get update \
 && apt-get install -y curl \
 && apt-get install -y wget \
 && apt-get install -y vim \

# Start in Home Dir (/root)
 && cd /root \

# Git
 && apt-get install -y git \

# SSH
 && apt-get install -y openssh-server \

# Java
 && apt-get install -y default-jdk \

# Sbt
 && wget https://s3-eu-west-1.amazonaws.com/distributed-pipeline/sbt-0.13.8.tgz \
 && tar xvzf sbt-0.13.8.tgz \
 && rm sbt-0.13.8.tgz \
 && ln -s /root/sbt/bin/sbt /usr/local/bin \

# Get Latest Pipeline Code
 && cd /root \
 && git clone https://github.com/distributed-freaks/pipeline.git \

# Sbt Clean
 && /root/sbt/bin/sbt clean clean-files

RUN \
# Start from ~
 cd /root \

# MySql (Required by Hive Metastore)
# Generic Install?  http://dev.mysql.com/doc/refman/5.7/en/binary-installation.html
 && DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server \
 && apt-get install -y mysql-client \
 && apt-get install -y libmysql-java \

# Apache Cassandra
 && wget https://s3-eu-west-1.amazonaws.com/distributed-pipeline/apache-cassandra-2.2.0-bin.tar.gz \
 && tar xvzf apache-cassandra-2.2.0-bin.tar.gz \
 && rm apache-cassandra-2.2.0-bin.tar.gz \

# Apache Kafka (Confluent Distribution)
 && wget https://s3-eu-west-1.amazonaws.com/distributed-pipeline/confluent-1.0-2.10.4.tar.gz \
 && tar xvzf confluent-1.0-2.10.4.tar.gz \
 && rm confluent-1.0-2.10.4.tar.gz \

# Apache Spark
 && wget https://s3-eu-west-1.amazonaws.com/distributed-pipeline/spark-1.4.1-bin-fluxcapacitor.tgz \
 && tar xvzf spark-1.4.1-bin-fluxcapacitor.tgz \
 && rm spark-1.4.1-bin-fluxcapacitor.tgz \

# Spark Notebook
 && apt-get install -y screen \
 && wget http://distributed-pipeline.s3.amazonaws.com/spark-notebook-master-scala-2.10.4-spark-1.4.1-hadoop-2.6.0-with-hive-with-parquet.tgz \
 && tar xvzf spark-notebook-master-scala-2.10.4-spark-1.4.1-hadoop-2.6.0-with-hive-with-parquet.tgz \
 && rm spark-notebook-master-scala-2.10.4-spark-1.4.1-hadoop-2.6.0-with-hive-with-parquet.tgz \
 && mv spark-notebook-* spark-notebook

RUN \
# Retrieve Latest Datasets, Configs, Code, and Start Scripts
 cd /root/pipeline \
 && git reset --hard && git pull \
 && chmod a+rx *.sh \

# .profile Shell Environment Variables
 && mv /root/.profile /root/.profile.orig \
 && ln -s /root/pipeline/config/bash/.profile /root/.profile \

# Sbt Assemble Feeder Producer App
 && cd /root/pipeline \
 && /root/sbt/bin/sbt feeder/assembly \

# Sbt Package Streaming Consumer App
 && cd /root/pipeline \
 && /root/sbt/bin/sbt streaming/package \

# Sbt Compile Fill Ivy "App"
 && cd /root/pipeline \
 && /root/sbt/bin/sbt fillIvy/compile

WORKDIR /root

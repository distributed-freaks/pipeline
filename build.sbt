val globalSettings = Seq(
  version := "1.0",
  scalaVersion := "2.10.4"
)

lazy val feeder = (project in file("feeder"))
                    .settings(name := "feeder")
                    .settings(globalSettings:_*)
                    .settings(libraryDependencies ++= feederDeps)

lazy val streaming = (project in file("streaming"))
                       .settings(name := "streaming")
                       .settings(globalSettings:_*)
                       .settings(libraryDependencies ++= streamingDeps)

// This repo's goal is to download deps needed in other project, like notebooks
lazy val fillIvy = (project in file("fill-ivy"))
                       .settings(name := "Filling Local Ivy Repo")
                       .settings(globalSettings:_*)
                       .settings(libraryDependencies ++= moreDeps)

val akkaVersion = "2.3.11"
val sparkVersion = "1.4.1"
val sparkCassandraConnectorVersion = "1.4.0"
val kafkaVersion = "0.8.2.1"
val scalaTestVersion = "2.2.4"

lazy val feederDeps = Seq(
  "com.typesafe.akka" %% "akka-actor" % akkaVersion,
  "com.typesafe.akka" %% "akka-testkit" % akkaVersion % "test",
  "org.scalatest" %% "scalatest" % scalaTestVersion % "test",
  "org.apache.kafka" % "kafka_2.10" % kafkaVersion
    exclude("javax.jms", "jms")
    exclude("com.sun.jdmk", "jmxtools")
    exclude("com.sun.jmx", "jmxri")
)

lazy val streamingDeps = Seq(
  "com.datastax.spark" % "spark-cassandra-connector_2.10" % sparkCassandraConnectorVersion,
  "org.apache.spark"  %% "spark-mllib"           % sparkVersion % "provided",
  "org.apache.spark"  %% "spark-graphx"          % sparkVersion % "provided",
  "org.apache.spark"  %% "spark-sql"             % sparkVersion % "provided",
  "org.apache.spark"  %% "spark-streaming"       % sparkVersion % "provided",
  "org.apache.spark"  %% "spark-streaming-kafka" % sparkVersion % "provided",
  "com.databricks"    %% "spark-csv"             % "1.2.0"
)

lazy val moreDeps = Seq(
  "org.bdgenomics.adam" % "adam-core" % "0.15.0" excludeAll(
    ExclusionRule("org.apache.hadoop", "hadoop-client"),
    ExclusionRule("org.apache.spark", "spark-core_2.10"),
    ExclusionRule("org.scala-lang"),
    ExclusionRule("org.scoverage")
  )
)
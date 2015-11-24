name := "rest-api"

scalaVersion := "2.11.7"

libraryDependencies ++= Seq(
	"com.typesafe.akka" %% "akka-http-experimental" % "1.0",
	"com.typesafe.akka" %% "akka-http-xml-experimental" % "1.0",
	"com.typesafe.akka" %% "akka-http-spray-json-experimental" % "1.0",
	"com.datastax.cassandra" % "cassandra-driver-core" % "2.1.8",
	"com.typesafe" % "config" % "1.2.0"
)
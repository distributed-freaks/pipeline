package pipeline.data

import java.net.InetSocketAddress
import java.util.Collections

import com.datastax.driver.core.Cluster
import com.datastax.driver.core.PreparedStatement
import com.datastax.driver.core.ResultSet
import com.typesafe.config.ConfigFactory

import scala.collection.JavaConverters._

object PipelineCluster {
  val config = ConfigFactory.load()
  val host = config.getString("cassandra.host")
  val port = config.getInt("cassandra.port")
  val keyspace = config.getString("cassandra.keyspace")
  val alleleTable = config.getString("cassandra.allele")

  lazy val cluster = Cluster.builder()
    .addContactPointsWithPorts(Collections.singleton(new InetSocketAddress(host, port)))
    .build()

  lazy val session = {
    println(s"Connecting to $host with keyspace $keyspace")
    cluster.connect(keyspace)
  }

  def close() {
    cluster.close()
  }

  /** A prepared statement is more efficient */
  lazy val allRecordsStatement = session.prepare(s"SELECT * from $alleleTable")

  /** A prepared statement for range queries. Only bound values are shipped for each query. */
  lazy val rangeQuery: PreparedStatement =
    session.prepare(s"""|SELECT * from $alleleTable
                        |WHERE population = ?
                        |AND chromosome = ?
                        |AND start > ?
                        |AND start < ? ;""".stripMargin)

  def rangeQuery(pop: String, chromosome: String, start: Int, end: Int): Seq[AlleleRecord] = {
    val resultSet = session.execute(
      rangeQuery.bind(pop, chromosome, new java.lang.Double(start), new java.lang.Double(end)))

    for (row <- resultSet.all().asScala)
      yield AlleleRecord.fromCassandraRow(row)
  }

  def allRecords(): Seq[AlleleRecord] = {
    val resultSet = session.execute(allRecordsStatement.bind())

    for (row <- resultSet.all().asScala)
      yield AlleleRecord.fromCassandraRow(row)
  }
}
package pipeline.data

import com.datastax.driver.core.Row

import spray.json.DefaultJsonProtocol

case class AlleleRecord(
  population: String,
  chromosome: String,
  start: Double,
  ref: String,
  alt: String,
  refCnt: Double,
  altCnt: Double)

object AlleleRecord {
  /**
   * Create a `AlleleRecord` instance from a Cassandra Row. It should match
   * the Cassandra table definition.
   */
  def fromCassandraRow(row: Row): AlleleRecord = {
    AlleleRecord(
      row.getString("population"),
      row.getString("chromosome"),
      row.getDouble("start"),
      row.getString("ref"),
      row.getString("alt"),
      row.getDouble("refcnt"),
      row.getDouble("altcnt"))
  }
}

/**
 * A protocol for serializing AlleleRecords to/from JSON.
 */
object AlleleProtocol extends DefaultJsonProtocol {
  implicit val colorFormat = jsonFormat7(AlleleRecord.apply)
}
package pipeline.rest

import scala.concurrent.Await
import scala.concurrent.Future
import scala.concurrent.duration.Duration
import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.server.Directives._
import akka.http.scaladsl.marshallers.xml.ScalaXmlSupport._
import akka.http.scaladsl.marshallers.sprayjson.SprayJsonSupport._
import akka.http.scaladsl.model._
import akka.stream.ActorMaterializer
import akka.stream.scaladsl.Sink
import akka.util.ByteString
import pipeline.data.PipelineCluster
import scala.collection.JavaConverters._
import spray.json._
import pipeline.data._

object Main extends App {
  implicit val system = ActorSystem("rest-api-system")
  implicit val materializer = ActorMaterializer()
  import system.dispatcher

  import AlleleProtocol._

  val route =
    get {
      path(Segment / Segment) { (population, chromosome) =>
        parameters("start".as[Int], "end".as[Int]) { (start, end) =>
          complete {
            PipelineCluster.rangeQuery(population, chromosome, start, end)
          }
        }
      } ~
      path("all") {
        complete {
          PipelineCluster.allRecords()
        }
      }

    }

  Http().bindAndHandle(route, "localhost", 1111)
  println("Press ENTER to terminate")
  Console.readLine()

  PipelineCluster.close()
  system.shutdown()
  system.awaitTermination()
}
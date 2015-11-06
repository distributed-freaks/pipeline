package pipeline.rest

import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.marshallers.sprayjson.SprayJsonSupport._
import akka.http.scaladsl.server.Directives._
import akka.stream.ActorMaterializer

import pipeline.data.PipelineCluster
import pipeline.data.AlleleProtocol

object Main extends App {
  implicit val system = ActorSystem("rest-api-system")
  implicit val materializer = ActorMaterializer()
  import system.dispatcher

  import AlleleProtocol._

  try {
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
  } finally {
    PipelineCluster.close()
    system.shutdown()
    system.awaitTermination()
  }
}
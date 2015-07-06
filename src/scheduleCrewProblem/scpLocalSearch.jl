type LocalSearch <: Metaheuristic

  runMetaheuristic::Function
  getBestCrewEdge::Function
  costNewSolution::Function
  model::Model
  resultsRunMetaheuristc::Array
  function LocalSearch(model::Model, numberMaxIterations = 10000,debugMode::Bool = false)
    this = new()
    this.model = model
    this.resultsRunMetaheuristc = zeros(Int64,numberMaxIterations)
    this.runMetaheuristic = function runMetaheuristic(solution)
      iterationNumber = 1
      i = 1
      edgeSize = model.data.edgeSize()
      time =
      iterationNotBetter = 1
      while ((iterationNumber < numberMaxIterations) && (time  < 10))
        tic()
        edge = model.data.getEdge(i)
        edgeId = edge[1]
        ids = getBestCrewEdge(Int64(edgeId),solution)
        idOldCrew = solution.initSolution[Int64(edgeId),2]

        if(costNewSolution(solution,edgeId,idOldCrew) > costNewSolution(solution,ids[1],ids[2]))
          solution.setCrewId(ids[1],ids[2])
          this.resultsRunMetaheuristc[iterationNumber] = solution.cost()
          iterationNotBetter = 1
        else
          iterationNotBetter = iterationNotBetter + 1
        end
        if(edgeSize > i)
          i = i + 1
        else
          i = 1
        end

        timeClock = (toq()) / 60
        time = timeClock + time

        if(debugMode)
          println("Iteration not better: ",iterationNotBetter)
          println("Iteration number:",iterationNumber)
          println("time = ",time)
          println("Cost = ",solution.cost())
        end

        iterationNumber = iterationNumber + 1
      end
      println("Ending LocalSearch")
    end

    this.getBestCrewEdge = function getBestCrewEdge(edgeId,solution)
      edge = model.data.getEdge(edgeId)
      edgeSolution = solution.initSolution[Int64(edgeId),:]

      initVertex =  edge[2]
      bestEdgeId = edgeId
      bestCrewId = solution.model.crews[edgeSolution[2]].id

      for crew in model.crews

        if(costNewSolution(solution,bestEdgeId,bestCrewId) > costNewSolution(solution,edgeId,crew.id))
          bestEdgeId = edgeId
          bestCrewId = crew.id
        end
      end
      return bestEdgeId, bestCrewId
    end

    this.costNewSolution = function costNewSolution(solution,edgeId,crewId)
      sumEdgeCost = 0
      for i=1:length(solution.initSolution[:,1])

        edgeSolution = solution.initSolution[i,:]

        if(Int64(edgeId) == Int64(edgeSolution[1]))
          crew = solution.model.crews[crewId]
        else
          crew = solution.model.crews[edgeSolution[2]]
        end

        edge = model.data.getEdge(Int64(edgeSolution[1]))
        sumEdgeCost = sumEdgeCost + solution.model.edgeCost(solution,edge,crew)
      end
      return sumEdgeCost
    end

    return this
  end

end

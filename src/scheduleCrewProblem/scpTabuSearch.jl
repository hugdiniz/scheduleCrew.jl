type TabuSearch <: Metaheuristic

  runMetaheuristic::Function
  containsTabuList::Function
  model::Model
  resultsRunMetaheuristc::Array
  localSearch::Metaheuristic
  bestSolution::Solution
  tabuList::Array
  function TabuSearch(model::Model, numberMaxIterations = 10000,debugMode::Bool = false)
    this = new()
    this.model = model
    this.resultsRunMetaheuristc = Array(Int64,model.data.edgeSize())
    this.localSearch = LocalSearch(model)
    this.runMetaheuristic = function runMetaheuristic(solution)
      iterationNumber = 1
      iterationNotBetter = 1
      i = 1
      edgeSize = model.data.edgeSize()
      this.tabuList = Array(Array,numberMaxIterations)
      time = 0
      bestSolution = ScheduleSolution(model,solution.initSolution)

      while ((iterationNumber < numberMaxIterations) && (time  < 10))
        tic()
        edge = model.data.getEdge(i)
        edgeId = edge[1]
        ids = this.localSearch.getBestCrewEdge(Int64(edgeId),solution)

        idOldCrew = bestSolution.initSolution[Int64(edgeId),2]

        if(this.localSearch.costNewSolution(bestSolution,edgeId,idOldCrew) > this.localSearch.costNewSolution(solution,ids[1],ids[2]))
          bestSolution.setCrewId(ids[1],ids[2])
          solution.setCrewId(ids[1],ids[2])
          this.tabuList[i] = copy(solution.initSolution)
          this.resultsRunMetaheuristc[iterationNumber] = solution.cost()
          iterationNotBetter = 1
        elseif(!containsTabuList(solution.initSolution))
          solution.setCrewId(ids[1],ids[2])
          this.tabuList[i] = copy(solution.initSolution)
          this.resultsRunMetaheuristc[iterationNumber] = solution.cost()
          iterationNotBetter = iterationNotBetter + 1
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
            println("cost: ",solution.cost())
            println("Iteration number:",iterationNumber)
            println("time = ",time)
        end

        iterationNumber = iterationNumber + 1
      end
      solution = bestSolution
      println("Ending tabuSearch")
      return solution
    end

    this.containsTabuList = function containsTabuList(initSolution)
      try
        for i=1:this.tabuList[1][:,2]
          if(initSolution[:,2] == this.tabuList[i][:,2])
            return true
            break;
          end
        end
        return false
      catch
        return false
      end
    end

    return this
  end
end

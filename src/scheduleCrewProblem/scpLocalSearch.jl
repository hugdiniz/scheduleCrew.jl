type LocalSearch <: Metaheuristic

    runMetaheuristic::Function
    getBestCrewEdge::Function
    costNewSolution::Function
    model::Model
    resultsRunMetaheuristc::Array
    function LocalSearch(model::Model)
        this = new()
        this.model = model
        this.resultsRunMetaheuristc = Array(Int64,model.data.edgeSize())
        this.runMetaheuristic = function runMetaheuristic(solution)
            iterationMax = 1
            i = 1
            edgeSize = model.data.edgeSize()
            time = 0
            while ((iterationMax < (edgeSize*10)) && (time  < 10))
                tic()
                edge = model.data.getEdge(i)
                edgeId = edge[1]
                ids = getBestCrewEdge(Int64(edgeId),solution)
                idOldCrew = solution.initSolution[Int64(edgeId),2]

                if(costNewSolution(solution,edgeId,idOldCrew) > costNewSolution(solution,ids[1],ids[2]))
                    experiment.solution.setCrewId(ids[1],ids[2])
                    this.resultsRunMetaheuristc[iterationMax] = solution.cost()
                end
                if(edgeSize > i)
                    i = i + 1
                else
                    i = 1
                end

                println("Iteration number:",iterationMax)
                iterationMax = iterationMax + 1
                timeClock = (toq()) / 60
                time = timeClock + time
                println("time = ",time)
            end
            println("End")
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

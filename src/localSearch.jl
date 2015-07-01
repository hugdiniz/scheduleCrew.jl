type LocalSearch <: Metaheuristic


    function LocalSearch()
        this = new()

        return this
    end

end

function runMetaheuristic(model,solution)
    iterationMax = 1
    i = 1
    edgeSize = model.data.edgeSize()
    while (iterationMax < (edgeSize*10))
        edge = model.data.getEdge(i)
        edgeId = edge[1]
        ids = getBestCrewEdge(model,Int64(edgeId),solution)
        if(solution.cost() > costNewSolution(model,solution,ids[1],ids[2]))
            println(solution.cost()," > ", costNewSolution(model,solution,ids[1],ids[2]))
            #println("Old solution: ",solution.cost())
            #println("Old solution: ",costNewSolution(model,solution,edgeId,solution.initSolution[Int64(edgeId),2]))

            experiment.solution.setCrewId(ids[1],ids[2])
            #println("New solution: ",solution.cost())
            println("New solution: ",costNewSolution(model,solution,ids[1],ids[2]))
        end
        if(edgeSize > i)
            i = i + 1
        else
            i = 1
        end
        iterationMax = iterationMax + 1
    end
end
function getBestCrewEdge(model::Model,edgeId,solution)
    edge = model.data.getEdge(edgeId)
    edgeSolution = solution.initSolution[Int64(edgeId),:]

    initVertex =  edge[2]
    bestEdgeId = edgeId
    bestCrewId = solution.model.crews[edgeSolution[2]].id

    for crew in model.crews

        if(costNewSolution(model,solution,bestEdgeId,bestCrewId) > costNewSolution(model,solution,edgeId,crew.id))
            bestEdgeId = edgeId
            bestCrewId = crew.id
        end
    end
    return bestEdgeId, bestCrewId
end

function costNewSolution(model::Model,solution,edgeId,crewId)
    sumEdgeCost = 0
    for i=1:length(solution.initSolution[:,1])

        edgeSolution = solution.initSolution[i,:]

        if(Int64(edgeId) == Int64(edgeSolution[1]))
            crew = solution.model.crews[crewId]
        else
            crew = solution.model.crews[edgeSolution[2]]
        end

        edge = model.data.getEdge(Int64(edgeSolution[1]))
        sumEdgeCost = sumEdgeCost + solution.model.edgeCost(edge,crew)
    end
    return sumEdgeCost
end

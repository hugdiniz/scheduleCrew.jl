type LocalSearch <: Metaheuristic


    function LocalSearch()
        this = new()

        return this
    end

end


function getBestCrewEdge(model::Model,edgeId,solution)
    edge = model.data.getEdge(edgeId)
    initVertex =  edge[2]
    bestSolution = solution
    tempSolution = solution

    for crew in model.crews
        tempSolution.setCrewId(edgeId,crew.id)
        if(bestSolution.cost() > tempSolution.cost())
            bestSolution = tempSolution
        end
    end
    return bestSolution
end

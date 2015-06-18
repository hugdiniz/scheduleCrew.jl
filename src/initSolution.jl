function initSolution(model::Model)
    dataset = model.data

    #intialSoluction Matrix:  edgeId -- crew
    initialSoluction = cell(dataset.edgeSize(),2)

    for i=1:dataset.edgeSize()
        edge = dataset.getEdge(i)
        bestCrew = findBestCrew(edge[2],model.crews)
        initialSoluction[i,1] = edge[1]
        initialSoluction[i,2] = bestCrew.id

        #adding bestCrew in soluction
        bestCrew.workTimes = edge[5] - edge[4]
        bestCrew.vertex = edge[3]
        model.crews[bestCrew.id] = bestCrew
    end
    return initialSoluction
end



function findBestCrew(initVertex,crews)
   bestCrew = null
   for crew in crews
        if bestCrew == null
            bestCrew = crew
        elseif crew.vertex == null
            bestCrew = crew
        elseif (bestCrew.vertex != initVertex)
            if(crew.vertex == null || crew.vertex == initVertex)
                bestCrew = crew
            elseif(bestCrew.workTimes > crew.workTimes)
                bestCrew = crew
            end
        elseif(bestCrew.vertex == initVertex && crew.vertex == initVertex)
            if(bestCrew.workTimes > crew.workTimes)
                bestCrew = crew
            end
        end

        if bestCrew.vertex == null
            break;
        end
    end
    return bestCrew
end



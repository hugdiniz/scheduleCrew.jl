abstract InitSolution

type ScheduleInitSolution <: InitSolution
    createSolution::Function
    findBestCrew::Function

    function ScheduleInitSolution()
        this = new()
        this.createSolution = function createSolution(model::Model)
            dataset = model.data

            #intialSoluction Matrix:  edgeId -- crew
            initialSoluction = cell(dataset.edgeSize(),2)

            for i=1:dataset.edgeSize()
                edge = dataset.getEdge(i)
                bestCrew = findBestCrew(edge,model.crews,model.costFunction)
                initialSoluction[i,1] = edge[1]
                initialSoluction[i,2] = bestCrew.id

                #adding bestCrew in soluction
                bestCrew.workTimes = bestCrew.workTimes +(edge[5] - edge[4])
                bestCrew.vertex = edge[3]
                model.crews[bestCrew.id] = bestCrew
            end
            return initialSoluction
        end

        this.findBestCrew = function findBestCrew(edge,crews,costFunction)
           initVertex =  edge[2]
           bestCrew = null
           for crew in crews
                if bestCrew == null
                    bestCrew = crew
                elseif crew.vertex == null
                    bestCrew = crew
                elseif (bestCrew.vertex != initVertex)
                    if(crew.vertex == null || crew.vertex == initVertex)
                        bestCrew = crew
                    elseif(costFunction(edge,bestCrew) > costFunction(edge,crew))
                        bestCrew = crew
                    end
                elseif(bestCrew.vertex == initVertex && crew.vertex == initVertex)
                    if(costFunction(edge,bestCrew) > costFunction(edge,crew))
                        bestCrew = crew
                    end
                end

                if bestCrew.vertex == null
                    break;
                end
            end
            return bestCrew
        end

        return this
    end

end

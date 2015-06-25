abstract Solution

type ScheduleSolution <: Solution
    createInitSolution::Function
    findBestCrew::Function
    cost::Function
    setCrewId::Function
    initSolution::Array
    function ScheduleSolution()
        this = new()
        this.createInitSolution = function createInitSolution(model::Model)
            dataset = model.data

            #initSolution Matrix:  edgeId -- idCrew
            initSolution = cell(dataset.edgeSize(),2)

            for i=1:dataset.edgeSize()
                edge = dataset.getEdge(i)
                bestCrew = findBestCrew(edge,model.crews,model.edgeCost)
                initSolution[i,1] = edge[1]
                initSolution[i,2] = bestCrew.id

                #adding bestCrew in soluction
                bestCrew.workTimes = bestCrew.workTimes +(edge[5] - edge[4])
                bestCrew.vertex = edge[3]
                model.crews[bestCrew.id] = bestCrew
            end
            return initSolution
        end

        this.findBestCrew = function findBestCrew(edge,crews,edgeCost)
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
                    elseif(edgeCost(edge,bestCrew) > edgeCost(edge,crew))
                        bestCrew = crew
                    end
                elseif(bestCrew.vertex == initVertex && crew.vertex == initVertex)
                    if(edgeCost(edge,bestCrew) > edgeCost(edge,crew))
                        bestCrew = crew
                    end
                end

                if bestCrew.vertex == null
                    break;
                end
            end
            return bestCrew
        end

        this.cost = function cost()
            sumEdgeCost = 0
            for edgeSolution in initSolution
                sumEdgeCost = sumEdgeCost + model.edgeCost(edge,model.crews[edgeSolution[2]])
            end
            return sumEdgeCost
        end

        this.setCrewId = function setCrewId(edgeId,crewId)

            for id in initSolution[:,1]
                if(edgeId = id)
                    edge = dataset.getEdge(edgeId)

                    oldIdCrew = initSolution[i,2]
                    model.crews[oldIdCrew].workTimes = model.crews[oldIdCrew].workTimes - (edge[5] - edge[4])

                    #adding bestCrew in soluction
                    initSolution[i,2] = crewId
                    model.crews[crewId].workTimes = model.crews[crewId].workTimes +(edge[5] - edge[4])
                    bestCrew.vertex = edge[3]
                    model.crews[bestCrew.id] = bestCrew
                end
            end

        end

        return this
    end

end

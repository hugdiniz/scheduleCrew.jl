abstract Solution

type ScheduleSolution <: Solution
    createInitSolution::Function
    findBestCrew::Function
    cost::Function
    setCrewId::Function
    initSolution::Array
    model::Model
    function ScheduleSolution()
        this = new()
        this.createInitSolution = function createInitSolution(model::Model)
            dataset = model.data
            this.model = model
            #initSolution Matrix:  edgeId -- idCrew
            this.initSolution = cell(dataset.edgeSize(),2)

            for i=1:dataset.edgeSize()
                edge = dataset.getEdge(i)
                bestCrew = findBestCrew(edge,model.crews,model.edgeCost)
                this.initSolution[i,1] = edge[1]
                this.initSolution[i,2] = bestCrew.id

                #adding bestCrew in soluction

                bestCrew.addEdge(edge)
                bestCrew.vertex = edge[3]
                model.crews[bestCrew.id] = bestCrew
            end
            return this.initSolution
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
            for i=1:length(this.initSolution[:,1])

                edgeSolution = this.initSolution[i,:]
                edge = this.model.data.getEdge(Int64(edgeSolution[1]))
                crew = this.model.crews[edgeSolution[2]]
                sumEdgeCost = sumEdgeCost + this.model.edgeCost(edge,crew)

            end
            return sumEdgeCost
        end

        this.setCrewId = function setCrewId(edgeId,crewId)

            for i=1:length(this.initSolution[:,1])
                id = this.initSolution[i,1]
                if(edgeId == id)
                    edge = dataset.getEdge(edgeId)

                    oldIdCrew = this.initSolution[i,2]
                    model.crews[oldIdCrew].removeEdge(edge)

                    model.crews[crewId].addEdge(edge)
                    model.crews[crewId].vertex = edge[3]

                    #oldIdCrew = this.initSolution[i,2]
                    #println("WorkTime: ",(edge[5] - edge[4]))
                    #println("OldId Before: ",model.crews[oldIdCrew].workTimes)
                    #model.crews[oldIdCrew].workTimes = model.crews[oldIdCrew].workTimes - (edge[5] - edge[4])
                    #println("OldId After:",model.crews[oldIdCrew].workTimes)
                    #adding bestCrew in soluction
                    #this.initSolution[i,2] = crewId
                    #println("newId Before: ",model.crews[crewId].workTimes)
                    #model.crews[crewId].workTimes = model.crews[crewId].workTimes +(edge[5] - edge[4])
                    #println("newId After:",model.crews[crewId].workTimes)
                    #model.crews[crewId].vertex = edge[3]
                    break
                end
            end

        end

        return this
    end

end
